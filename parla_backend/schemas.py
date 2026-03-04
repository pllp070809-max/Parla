"""Pydantic schemas – API."""
from datetime import datetime
from pydantic import BaseModel


class SalonList(BaseModel):
    id: int
    name: str
    address: str | None
    category: str | None
    image_key: str | None
    latitude: float | None
    longitude: float | None

    class Config:
        from_attributes = True


class ServiceOut(BaseModel):
    id: int
    name: str
    duration_minutes: int
    price: float | None

    class Config:
        from_attributes = True


class SalonDetail(SalonList):
    services: list[ServiceOut] = []


class BookingCreate(BaseModel):
    salon_id: int
    service_id: int
    guest_name: str
    guest_phone: str
    slot_at: datetime


class BookingOut(BaseModel):
    id: int
    salon_id: int
    service_id: int
    guest_name: str
    guest_phone: str
    slot_at: datetime
    status: str

    class Config:
        from_attributes = True
