module PicturesHelper
  def can_edit_picture?(picture)
    signed_in? && current_user == picture.album.user
  end
end
