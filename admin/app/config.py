from dataclasses import dataclass, field
from pathlib import Path

ALLOWED_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".heic", ".heif"}
TRANSPARENT_FORMATS = {".png", ".webp"}
ALWAYS_REMOVE_BG = {".jpg", ".jpeg", ".heic", ".heif"}


@dataclass
class Settings:
    target_dir: Path = field(default_factory=lambda: (
        Path(__file__).resolve().parent.parent.parent / "input" / "transparent-background"
    ))

    def validate(self) -> None:
        self.target_dir.mkdir(parents=True, exist_ok=True)
