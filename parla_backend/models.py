"""DB modelleri – MVP."""
from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey
from sqlalchemy.orm import relationship

from database import Base


class Salon(Base):
    __tablename__ = "salons"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    address = Column(String(512))
    category = Column(String(64))
    image_key = Column(String(128))

    services = relationship("Service", back_populates="salon")


class Service(Base):
    __tablename__ = "services"
    id = Column(Integer, primary_key=True, index=True)
    salon_id = Column(Integer, ForeignKey("salons.id"), nullable=False)
    name = Column(String(255), nullable=False)
    duration_minutes = Column(Integer, default=30)
    price = Column(Float, nullable=True)

    salon = relationship("Salon", back_populates="services")


class Booking(Base):
    __tablename__ = "bookings"
    id = Column(Integer, primary_key=True, index=True)
    salon_id = Column(Integer, ForeignKey("salons.id"), nullable=False)
    service_id = Column(Integer, ForeignKey("services.id"), nullable=False)
    guest_name = Column(String(255), nullable=False)
    guest_phone = Column(String(32), nullable=False)
    slot_at = Column(DateTime, nullable=False)
    status = Column(String(32), default="confirmed")
