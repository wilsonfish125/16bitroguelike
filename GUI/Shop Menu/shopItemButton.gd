class_name ShopItemButton extends Button

var item : ItemData


# Setup the button
func setupItem( _item : ItemData ) -> void:
	item = _item
	$Label.text = item.name
	$PriceLabel.text = str( item.cost ) 
	$TextureRect.texture = item.texture
