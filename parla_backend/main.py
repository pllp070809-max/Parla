"""Parla API – FastAPI MVP."""
from contextlib import asynccontextmanager
from datetime import datetime, time, timedelta
from fastapi import FastAPI, Depends, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.orm import selectinload

from database import get_db, engine, Base
from models import Salon, Service, Booking
from schemas import SalonList, SalonDetail, ServiceOut, BookingCreate, BookingOut, BookingStatusUpdate

PHONE_PREFIX = "+993"
SLOT_START = time(9, 0)
SLOT_END = time(18, 0)
SLOT_STEP_MINUTES = 30


def normalize_phone(raw: str) -> str:
    digits = "".join(c for c in raw if c.isdigit())
    if digits.startswith("993"):
        digits = digits[3:]
    return PHONE_PREFIX + digits.lstrip("0")


@asynccontextmanager
async def lifespan(app: FastAPI):
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    await engine.dispose()


app = FastAPI(title="Parla API", lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/salons", response_model=list[SalonList])
async def list_salons(
    category: str | None = Query(None),
    db: AsyncSession = Depends(get_db),
):
    q = select(Salon)
    if category:
        q = q.where(Salon.category == category)
    r = await db.execute(q)
    return list(r.scalars().all())


@app.get("/salons/{salon_id}", response_model=SalonDetail)
async def get_salon(salon_id: int, db: AsyncSession = Depends(get_db)):
    r = await db.execute(
        select(Salon).where(Salon.id == salon_id).options(selectinload(Salon.services))
    )
    salon = r.scalar_one_or_none()
    if not salon:
        raise HTTPException(404, "Salon tapylmady")
    return salon


@app.get("/salons/{salon_id}/slots")
async def get_slots(
    salon_id: int,
    date: str = Query(..., description="YYYY-MM-DD"),
    service_id: int = Query(..., description="Hyzmat ID – duration boýunça çaknaşma hasaplanýar"),
    db: AsyncSession = Depends(get_db),
):
    try:
        d = datetime.strptime(date, "%Y-%m-%d").date()
    except ValueError:
        raise HTTPException(400, "Sene formaty: YYYY-MM-DD")

    r = await db.execute(select(Service).where(Service.id == service_id, Service.salon_id == salon_id))
    service = r.scalar_one_or_none()
    if not service:
        raise HTTPException(404, "Hyzmat tapylmady")

    duration_min = service.duration_minutes
    start_dt = datetime.combine(d, SLOT_START)
    end_dt = datetime.combine(d, SLOT_END)

    r = await db.execute(
        select(Booking, Service.duration_minutes).join(Service, Booking.service_id == Service.id).where(
            Booking.salon_id == salon_id,
            Booking.slot_at >= start_dt,
            Booking.slot_at < end_dt + timedelta(days=1),
            Booking.status == "confirmed",
        )
    )
    occupied_ranges = []
    for row in r.all():
        book_start = row[0].slot_at
        book_end = book_start + timedelta(minutes=row[1])
        occupied_ranges.append((book_start, book_end))

    slots = []
    current = start_dt
    slot_end_dt = current + timedelta(minutes=duration_min)
    while slot_end_dt <= end_dt:
        overlap = any(
            current < end and slot_end_dt > start for start, end in occupied_ranges
        )
        if not overlap:
            slots.append(current.isoformat())
        current += timedelta(minutes=SLOT_STEP_MINUTES)
        slot_end_dt = current + timedelta(minutes=duration_min)

    return {"date": date, "service_id": service_id, "slots": slots}


@app.post("/bookings", response_model=BookingOut)
async def create_booking(body: BookingCreate, db: AsyncSession = Depends(get_db)):
    phone = normalize_phone(body.guest_phone)

    r = await db.execute(select(Service).where(Service.id == body.service_id))
    service = r.scalar_one_or_none()
    if not service or service.salon_id != body.salon_id:
        raise HTTPException(404, "Hyzmat tapylmady")

    duration_min = service.duration_minutes
    new_start = body.slot_at
    new_end = new_start + timedelta(minutes=duration_min)

    day_start = datetime.combine(new_start.date(), time(0, 0))
    day_end = day_start + timedelta(days=1)
    r = await db.execute(
        select(Booking, Service.duration_minutes)
        .join(Service, Booking.service_id == Service.id)
        .where(
            Booking.salon_id == body.salon_id,
            Booking.status == "confirmed",
            Booking.slot_at >= day_start,
            Booking.slot_at < day_end,
        )
    )
    for row in r.all():
        start, dur = row[0].slot_at, row[1]
        end = start + timedelta(minutes=dur)
        if new_start < end and new_end > start:
            raise HTTPException(
                409,
                "Bagyşlaň, bu wagt eýýäm alyndy.",
            )

    b = Booking(
        salon_id=body.salon_id,
        service_id=body.service_id,
        guest_name=body.guest_name,
        guest_phone=phone,
        slot_at=body.slot_at,
    )
    db.add(b)
    await db.commit()
    await db.refresh(b)
    return b


@app.get("/bookings", response_model=list[BookingOut])
async def list_bookings_by_phone(
    phone: str = Query(..., description="Müşderi telefon nomeri"),
    db: AsyncSession = Depends(get_db),
):
    normalized = normalize_phone(phone)
    r = await db.execute(
        select(Booking, Salon.name, Service.name)
        .join(Salon, Booking.salon_id == Salon.id)
        .join(Service, Booking.service_id == Service.id)
        .where(Booking.guest_phone == normalized)
        .order_by(Booking.slot_at.desc())
    )
    return [
        BookingOut(
            id=b.id,
            salon_id=b.salon_id,
            service_id=b.service_id,
            guest_name=b.guest_name,
            guest_phone=b.guest_phone,
            slot_at=b.slot_at,
            status=b.status,
            salon_name=salon_name,
            service_name=service_name,
        )
        for b, salon_name, service_name in r.all()
    ]


@app.patch("/bookings/{booking_id}", response_model=BookingOut)
async def cancel_booking(
    booking_id: int,
    body: BookingStatusUpdate,
    phone: str = Query(..., description="Müşderi telefon nomeri – ygtyýarlyk üçin"),
    db: AsyncSession = Depends(get_db),
):
    if body.status != "cancelled":
        raise HTTPException(400, "Diňe status 'cancelled' rugsat berilýär")
    normalized = normalize_phone(phone)
    r = await db.execute(
        select(Booking, Salon.name, Service.name)
        .join(Salon, Booking.salon_id == Salon.id)
        .join(Service, Booking.service_id == Service.id)
        .where(Booking.id == booking_id)
    )
    row = r.one_or_none()
    if not row:
        raise HTTPException(404, "Bron tapylmady")
    b, salon_name, service_name = row
    if b.guest_phone != normalized:
        raise HTTPException(403, "Bu bron siziň nomeriňize degişli däl")
    b.status = "cancelled"
    await db.commit()
    await db.refresh(b)
    return BookingOut(
        id=b.id,
        salon_id=b.salon_id,
        service_id=b.service_id,
        guest_name=b.guest_name,
        guest_phone=b.guest_phone,
        slot_at=b.slot_at,
        status=b.status,
        salon_name=salon_name,
        service_name=service_name,
    )
