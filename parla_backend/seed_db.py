"""Bir gezek işledilýär – test salonlar we hyzmatlar."""
import asyncio
from sqlalchemy import select
from database import engine, AsyncSessionLocal, Base
from models import Salon, Service


async def seed():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

    async with AsyncSessionLocal() as db:
        r = await db.execute(select(Salon).limit(1))
        if r.scalar_one_or_none():
            print("DB-de eýýäm salon bar, seed atlandy.")
            return

        s1 = Salon(
            name="Parla Salon",
            address="Asgabat, Görogly 1",
            category="salon",
            image_key="salon1",
        )
        db.add(s1)
        await db.flush()
        db.add(Service(salon_id=s1.id, name="Saç kesim", duration_minutes=30, price=50.0))
        db.add(Service(salon_id=s1.id, name="Sakal", duration_minutes=15, price=20.0))
        db.add(Service(salon_id=s1.id, name="Boýama", duration_minutes=60, price=120.0))

        s2 = Salon(
            name="Style Barber",
            address="Asgabat, Magtymguly 15",
            category="barber",
            image_key="salon2",
        )
        db.add(s2)
        await db.flush()
        db.add(Service(salon_id=s2.id, name="Saç kesim", duration_minutes=30, price=40.0))
        db.add(Service(salon_id=s2.id, name="Sakal", duration_minutes=20, price=25.0))

        s3 = Salon(
            name="Relax Spa",
            address="Asgabat, Bitarap Türkmenistan 22",
            category="spa",
            image_key="salon3",
        )
        db.add(s3)
        await db.flush()
        db.add(Service(salon_id=s3.id, name="Massaž", duration_minutes=60, price=150.0))
        db.add(Service(salon_id=s3.id, name="Ýüz", duration_minutes=45, price=80.0))

        await db.commit()
    print("Seed tamamlandy: 3 salon, 7 hyzmat.")


if __name__ == "__main__":
    asyncio.run(seed())
