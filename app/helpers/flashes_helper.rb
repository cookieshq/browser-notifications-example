module FlashesHelper
  FLASH_CLASSES = {
    "alert" => "warning",
    "notice" => "info"
  }
  def user_facing_flashes
    flash.to_hash.slice("alert", "error", "notice", "success")
  end

  def flash_class(key)
    FLASH_CLASSES[key]
  end
end
