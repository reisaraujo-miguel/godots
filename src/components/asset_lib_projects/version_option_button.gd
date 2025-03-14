class_name GodotVersionOptionButton
extends OptionButton

signal changed

var _src: Src


func _init() -> void:
	item_selected.connect(func(_idx: int) -> void: changed.emit())


func init(src: Src) -> void:
	_src = src


func async_load_versions() -> Array[String]:
	clear()
	var errors: Array[String] = []
	@warning_ignore("redundant_await")
	var versions := await _src.async_fetch(errors)
	for i in range(len(versions)):
		add_item(versions[i])
		set_item_metadata(i, versions[i])
	return errors


func fill_params(params: AssetLib.Params) -> void:
	params.godot_version = get_selected_metadata()


class Src:
	func async_fetch(errors: Array[String] = []) -> PackedStringArray:
		return []


class SrcMock:
	extends Src
	var _data: PackedStringArray

	func _init(data: PackedStringArray) -> void:
		_data = data

	func async_fetch(errors: Array[String] = []) -> PackedStringArray:
		return _data


class SrcGithubYml:
	extends Src
	var _yml_src: RemoteEditorsTreeDataSourceGithub.YmlSource
	var _name_regex := RegEx.create_from_string('(?m)\\sname:\\s"(?<name>[^"]+)"$')

	func _init(yml_src: RemoteEditorsTreeDataSourceGithub.YmlSource) -> void:
		_yml_src = yml_src

	func async_fetch(errors: Array[String] = []) -> PackedStringArray:
		@warning_ignore("redundant_await")
		var yml := await _yml_src.async_load(errors)
		var versions := _name_regex.search_all(yml)
		var result: PackedStringArray = []
		for version_result in versions:
			var version := version_result.get_string("name")
			version = version.substr(0, 3)
			if not version.is_valid_float():
				continue
			if not version in result:
				result.append(version)
		if len(result) == 0:
			errors.append(tr("Empty versions list!"))
		return result


func _on_fetch_disable() -> void:
	disabled = true


func _on_fetch_enable() -> void:
	disabled = false
