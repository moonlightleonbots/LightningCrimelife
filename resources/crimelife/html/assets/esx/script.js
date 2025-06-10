let currentScript = ''

// LIST
// let menuListTemplate =
// 	'<div id="menu_list_{{_namespace}}_{{_name}}" class="menu_list">' +
// 		'<table>' +
// 			'<thead>' +
// 				'<tr>' +
// 					'{{#head}}<td>{{content}}</td>{{/head}}' +
// 				'</tr>' +
// 			'</thead>'+
// 			'<tbody>' +
// 				'{{#rows}}' +
// 					'<tr>' +
// 						'{{#cols}}<td>{{{content}}}</td>{{/cols}}' +
// 					'</tr>' +
// 				'{{/rows}}' +
// 			'</tbody>' +
// 		'</table>' +
// 	'</div>'
// ;

$('#menu_default').hide()

let menuDefaultTemplate = '<div id="menu_default_{{_namespace}}_{{_name}}" class="menu{{#align}} align-{{align}}{{/align}}">' +
	'<div class="head">' +
	'<span>{{{title}}}</span>' +
	'</div>' +
	'<div class="menu-items">' +
	'{{#elements}}' +
	'<div class="main__list-item {{#selected}}selected{{/selected}}">' +
	'{{{label}}}{{#isSlider}} <div class="arrows"><div class="arrowbg"><i class="fa-solid fa-arrow-left"></i></div>{{{sliderLabel}}}<div class="arrowbg"><i class="fa-solid fa-arrow-right"></i></div></div>{{/isSlider}}' +
	'</div>' +
	'{{/elements}}' +
	'</div>' +
	'</div>' +
	'</div>'

ESX_MENU_DEFAULT = {}
ESX_MENU_DEFAULT.opened = {}
ESX_MENU_DEFAULT.focus = []
ESX_MENU_DEFAULT.pos = {}

ESX_MENU_DEFAULT.open = function (namespace, name, data) {
	if (typeof ESX_MENU_DEFAULT.opened[namespace] == 'undefined') {
		ESX_MENU_DEFAULT.opened[namespace] = {}
	}

	if (typeof ESX_MENU_DEFAULT.opened[namespace][name] != 'undefined') {
		ESX_MENU_DEFAULT.close(namespace, name)
	}

	if (typeof ESX_MENU_DEFAULT.pos[namespace] == 'undefined') {
		ESX_MENU_DEFAULT.pos[namespace] = {}
	}

	for (let i = 0; i < data.elements.length; i++) {
		if (typeof data.elements[i].type == 'undefined') {
			data.elements[i].type = 'default'
		}
	}

	data._index = ESX_MENU_DEFAULT.focus.length
	data._namespace = namespace
	data._name = name

	for (let i = 0; i < data.elements.length; i++) {
		data.elements[i]._namespace = namespace
		data.elements[i]._name = name
	}

	ESX_MENU_DEFAULT.opened[namespace][name] = data
	ESX_MENU_DEFAULT.pos[namespace][name] = 0

	for (let i = 0; i < data.elements.length; i++) {
		if (data.elements[i].selected) {
			ESX_MENU_DEFAULT.pos[namespace][name] = i
		} else {
			data.elements[i].selected = false
		}
	}

	ESX_MENU_DEFAULT.focus.push({
		namespace: namespace,
		name: name
	})

	ESX_MENU_DEFAULT.render()
	$('#menu_default_' + namespace + '_' + name).find('.main__list-item.selected')[0].scrollIntoView();
}

ESX_MENU_DEFAULT.close = function (namespace, name) {
	delete ESX_MENU_DEFAULT.opened[namespace][name]

	for (let i = 0; i < ESX_MENU_DEFAULT.focus.length; i++) {
		if (ESX_MENU_DEFAULT.focus[i].namespace == namespace && ESX_MENU_DEFAULT.focus[i].name == name) {
			ESX_MENU_DEFAULT.focus.splice(i, 1)
			break
		}
	}
	ESX_MENU_DEFAULT.render()
}

ESX_MENU_DEFAULT.render = function () {
	let menuContainer = document.getElementById('menu_default')
	let focused = ESX_MENU_DEFAULT.getFocused()
	menuContainer.innerHTML = ''

	$(menuContainer).hide()

	for (let namespace in ESX_MENU_DEFAULT.opened) {
		for (let name in ESX_MENU_DEFAULT.opened[namespace]) {

			let menuData = ESX_MENU_DEFAULT.opened[namespace][name]
			let view = JSON.parse(JSON.stringify(menuData))

			for (let i = 0; i < menuData.elements.length; i++) {
				let element = view.elements[i]

				switch (element.type) {
					case 'default':
						break
					case 'slider': {
						element.isSlider = true
						element.sliderLabel = (typeof element.options == 'undefined') ? element.value : element.options[element.value]
					}
						break
					default:
						break
				}

				if (i == ESX_MENU_DEFAULT.pos[namespace][name]) {
					element.selected = true
				}
			}

			let menu = $(Mustache.render(menuDefaultTemplate, view))[0]
			$(menu).hide()
			menuContainer.appendChild(menu)
		}
	}

	if (typeof focused != 'undefined') {
		$('#menu_default_' + focused.namespace + '_' + focused.name).show()
	}

	$(menuContainer).show()
}

ESX_MENU_DEFAULT.submit = function (namespace, name, data) {
	$.post('https://crimelife/default/menu_submit', JSON.stringify({
		_namespace: namespace,
		_name: name,
		current: data,
		elements: ESX_MENU_DEFAULT.opened[namespace][name].elements
	}))
}

ESX_MENU_DEFAULT.cancel = function (namespace, name) {
	$.post('https://crimelife/default/menu_cancel', JSON.stringify({
		_namespace: namespace,
		_name: name
	}))
}

ESX_MENU_DEFAULT.change = function (namespace, name, data) {
	$.post('https://crimelife/default/menu_change', JSON.stringify({
		_namespace: namespace,
		_name: name,
		current: data,
		elements: ESX_MENU_DEFAULT.opened[namespace][name].elements
	}))
}

ESX_MENU_DEFAULT.getFocused = function () {
	return ESX_MENU_DEFAULT.focus[ESX_MENU_DEFAULT.focus.length - 1]
}

ESX_MENU_DIALOG = {}
ESX_MENU_DIALOG.opened = {}
ESX_MENU_DIALOG.focus = []
ESX_MENU_DIALOG.pos = {}
ESX_MENU_DIALOG.DATA = {}

// let menuDialogTemplate =
// '<div id="menu_{{_namespace}}_{{_name}}" class="menu_dialog {{#isBig}}big{{/isBig}}">' +
//     '<h2>{{title}}</h2>' +
//     '{{#isDefault}}<input type="text" name="value" id="inputText"/>{{/isDefault}}' +
//     '{{#isBig}}<textarea name="value"/>{{/isBig}}' +
//     '<button type="button" name="submit">Bestätigen</button>' +
//     '<button type="button" name="cancel">Abbrechen</button>';
// "</div>" + "</div>"
// ;

let menuDialogTemplate = `
<div class="main__dialog_container">
	<div class="main_dialog_header">
		<div class="main__dialog_top-header">
			<p>LIGHTNING</p>
		</div>
		<div class="main__dialog_top-secondary-header">
			<p>{{title}}</p>
		</div>
	</div>
	<div class="main__dialog_content-container" id="menu_{{_namespace}}_{{_name}}">
		<div class="main__dialog_content-input-container">
			<input type="text" name="value" id="inputText">
		</div>
		<div class="main__dialog_content-button-grid">
			<button class="main__dialog_content-button-agree" name="submit">Bestätigen</button>
			<button class="main__dialog_content-button-decline" name="cancel">Abbrechen</button>
		</div>
	</div>
</div>
`

ESX_MENU_DIALOG.open = function (namespace, name, data) {
	if (typeof ESX_MENU_DIALOG.opened[namespace] == "undefined")
		ESX_MENU_DIALOG.opened[namespace] = {}

	if (typeof ESX_MENU_DIALOG.opened[namespace][name] != "undefined")
		ESX_MENU_DIALOG.close(namespace, name)

	if (typeof ESX_MENU_DIALOG.pos[namespace] == "undefined")
		ESX_MENU_DIALOG.pos[namespace] = {}

	if (typeof data.type == "undefined") data.type = "default"

	if (typeof data.align == "undefined") data.align = "top-left"

	data._index = ESX_MENU_DIALOG.focus.length
	data._namespace = namespace
	data._name = name

	ESX_MENU_DIALOG.opened[namespace][name] = data
	ESX_MENU_DIALOG.pos[namespace][name] = 0

	ESX_MENU_DIALOG.focus.push({
		namespace: namespace,
		name: name,
	})

	ESX_MENU_DIALOG.DATA = data

	ESX_MENU_DIALOG.render()
}

ESX_MENU_DIALOG.close = function (namespace, name) {
	delete ESX_MENU_DIALOG.opened[namespace][name]

	for (let i = 0; i < ESX_MENU_DIALOG.focus.length; i++) {
		if (ESX_MENU_DIALOG.focus[i].namespace == namespace && ESX_MENU_DIALOG.focus[i].name == name) {
			ESX_MENU_DIALOG.focus.splice(i, 1)
			break
		}
	}

	ESX_MENU_DIALOG.render()
}

ESX_MENU_DIALOG.render = function () {
	let menuContainer = $("#menu_dialog")[0]

	$(menuContainer).find('button[name="submit"]').unbind("click")
	$(menuContainer).find('button[name="cancel"]').unbind("click")
	$(menuContainer).find('[name="value"]').unbind("input propertychange")

	menuContainer.innerHTML = ""

	$(menuContainer).hide()

	for (let namespace in ESX_MENU_DIALOG.opened) {
		for (let name in ESX_MENU_DIALOG.opened[namespace]) {
			let menuData = ESX_MENU_DIALOG.opened[namespace][name]
			let view = JSON.parse(JSON.stringify(menuData))

			switch (menuData.type) {
				case "default": {
					view.isDefault = true
					break
				}
				case "big": {
					view.isBig = true
					break
				}
				default:
					break
			}

			let menu = $(Mustache.render(menuDialogTemplate, view))[0]

			$(menu).css("z-index", 1000 + view._index)

			$(menu).find('button[name="submit"]').click(function () {
				ESX_MENU_DIALOG.submit(this.namespace, this.name, this.data)
			}.bind({ namespace: namespace, name: name, data: menuData }))

			$(menu).find('button[name="cancel"]').click(function () {
				ESX_MENU_DIALOG.cancel(this.namespace, this.name, this.data)
			}.bind({ namespace: namespace, name: name, data: menuData }))

			$(menu).find('[name="value"]').bind("input propertychange", function () {
				this.data.value = $(menu).find('[name="value"]').val()
				ESX_MENU_DIALOG.change(this.namespace, this.name, this.data)
			}.bind({ namespace: namespace, name: name, data: menuData }))

			if (typeof menuData.value != "undefined")
				$(menu).find('[name="value"]').val(menuData.value)

			menuContainer.appendChild(menu)
		}
	}

	$(menuContainer).show()
	$("#inputText").focus()
}

ESX_MENU_DIALOG.submit = function (namespace, name, data) {
	$.post("https://crimelife/dialog/menu_submit", JSON.stringify(data))
}

ESX_MENU_DIALOG.cancel = function (namespace, name, data) {
	$.post("https://crimelife/dialog/menu_cancel", JSON.stringify(data))
}

ESX_MENU_DIALOG.change = function (namespace, name, data) {
	$.post("https://crimelife/dialog/menu_change", JSON.stringify(data))
}

ESX_MENU_DIALOG.getFocused = function () {
	return ESX_MENU_DIALOG.focus[ESX_MENU_DIALOG.focus.length - 1]
}

$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.script) {
			case 'extended':
				switch (event.data.action) {
					case 'inventoryNotification':
						let notif = ''

						if (event.data.add) {
							notif += '+'
						} else {
							notif += '-'
						}

						if (event.data.count) {
							notif += event.data.count + ' ' + event.data.item
						} else {
							notif += '' + event.data.item
						}

						let element = $('<div>' + notif + '</div>')
						$('.inventory_notify').append(element).fadeIn()

						$(element).delay(3000).fadeOut(1000, function () {
							element.remove()
						})
						break
				}
				break
			case 'list':
				switch (event.data.action) {
					case 'openMenu':
						currentScript = 'list'
						ESX_MENU_LIST.open(event.data.namespace, event.data.name, event.data.data)
						break
					case 'closeMenu':
						ESX_MENU_LIST.close(event.data.namespace, event.data.name)
						break
				}
				break
			case 'default':
				switch (event.data.action) {
					case 'openMenu':
						currentScript = 'default'
						ESX_MENU_DEFAULT.open(event.data.namespace, event.data.name, event.data.data)
						break
					case 'closeMenu':
						ESX_MENU_DEFAULT.close(event.data.namespace, event.data.name)
						break
					case 'controlPressed':
						switch (event.data.control) {
							case 'ENTER': {
								let focused = ESX_MENU_DEFAULT.getFocused()

								if (typeof focused != 'undefined') {
									let menu = ESX_MENU_DEFAULT.opened[focused.namespace][focused.name]
									let pos = ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]
									let elem = menu.elements[pos]

									if (menu.elements.length > 0) {
										ESX_MENU_DEFAULT.submit(focused.namespace, focused.name, elem)
									}
								}
								break
							}

							case 'BACKSPACE': {
								if (!canExit) {
									let focused = ESX_MENU_DEFAULT.getFocused();
									if (typeof focused != 'undefined') {
										ESX_MENU_DEFAULT.cancel(focused.namespace, focused.name);
									}
								}
								break
							}
							case 'TOP': {
								let focused = ESX_MENU_DEFAULT.getFocused()

								if (typeof focused != 'undefined') {

									let menu = ESX_MENU_DEFAULT.opened[focused.namespace][focused.name]
									let pos = ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]

									if (pos > 0) {
										ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]--
									} else {
										ESX_MENU_DEFAULT.pos[focused.namespace][focused.name] = menu.elements.length - 1
									}

									let elem = menu.elements[ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]]

									for (let i = 0; i < menu.elements.length; i++) {
										if (i == ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]) {
											menu.elements[i].selected = true
										} else {
											menu.elements[i].selected = false
										}
									}

									ESX_MENU_DEFAULT.change(focused.namespace, focused.name, elem)
									ESX_MENU_DEFAULT.render()

									$('#menu_default_' + focused.namespace + '_' + focused.name).find('.main__list-item.selected')[0].scrollIntoView();
								}
								break
							}
							case 'DOWN': {
								let focused = ESX_MENU_DEFAULT.getFocused()

								if (typeof focused != 'undefined') {
									let menu = ESX_MENU_DEFAULT.opened[focused.namespace][focused.name]
									let pos = ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]
									let length = menu.elements.length

									if (pos < length - 1) {
										ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]++
									} else {
										ESX_MENU_DEFAULT.pos[focused.namespace][focused.name] = 0
									}

									let elem = menu.elements[ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]]

									for (let i = 0; i < menu.elements.length; i++) {
										if (i == ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]) {
											menu.elements[i].selected = true
										} else {
											menu.elements[i].selected = false
										}
									}

									ESX_MENU_DEFAULT.change(focused.namespace, focused.name, elem)
									ESX_MENU_DEFAULT.render()

									$('#menu_default_' + focused.namespace + '_' + focused.name).find('.main__list-item.selected')[0].scrollIntoView();
								}
								break
							}
							case 'LEFT': {
								let focused = ESX_MENU_DEFAULT.getFocused()

								if (typeof focused != 'undefined') {
									let menu = ESX_MENU_DEFAULT.opened[focused.namespace][focused.name]
									let pos = ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]
									let elem = menu.elements[pos]

									switch (elem.type) {
										case 'slider': {
											let min = (typeof elem.min == 'undefined') ? 0 : elem.min

											if (elem.value > min) {
												elem.value--
												ESX_MENU_DEFAULT.change(focused.namespace, focused.name, elem)
											}

											ESX_MENU_DEFAULT.render()
										}
											break

										default:
											break
									}

									$('#menu_default_' + focused.namespace + '_' + focused.name).find('.main__list-item.selected')[0].scrollIntoView();
								}
								break
							}
							case 'RIGHT': {
								let focused = ESX_MENU_DEFAULT.getFocused()

								if (typeof focused != 'undefined') {
									let menu = ESX_MENU_DEFAULT.opened[focused.namespace][focused.name]
									let pos = ESX_MENU_DEFAULT.pos[focused.namespace][focused.name]
									let elem = menu.elements[pos]

									switch (elem.type) {
										case 'slider': {
											if (typeof elem.options != 'undefined' && elem.value < elem.options.length - 1) {
												elem.value++
												ESX_MENU_DEFAULT.change(focused.namespace, focused.name, elem)
											}

											if (typeof elem.max != 'undefined' && elem.value < elem.max) {
												elem.value++
												ESX_MENU_DEFAULT.change(focused.namespace, focused.name, elem)
											}

											ESX_MENU_DEFAULT.render()
										}
											break

										default:
											break
									}

									$('#menu_default_' + focused.namespace + '_' + focused.name).find('.main__list-item.selected')[0].scrollIntoView();
								}
								break
							}
						}
						break
				}
				break
			case 'dialog':
				switch (event.data.action) {
					case 'openMenu':
						currentScript = 'dialog'
						ESX_MENU_DIALOG.open(event.data.namespace, event.data.name, event.data.data)
						break
					case 'closeMenu':
						ESX_MENU_DIALOG.close(event.data.namespace, event.data.name)
						break
				}
				break
		}
	})

	window.addEventListener('keyup', function (data) {
		switch (data.which) {
			case 27:
				closeAll();

				switch (currentScript) {
					case 'list':
						let focused = ESX_MENU_LIST.getFocused();
						ESX_MENU_LIST.cancel(focused.namespace, focused.name);
						break;
					case 'dialog':
						$.post("https://crimelife/dialog/menu_cancel", JSON.stringify(ESX_MENU_DIALOG.DATA));
						break;
				}
				break;

			case 13:
				switch (currentScript) {
					case 'dialog':
						$.post("https://crimelife/dialog/menu_submit", JSON.stringify(ESX_MENU_DIALOG.DATA));
						break;
				}

				if (firstCam) {
					firstCam = false;
					canExit = false

					$('.animationText').fadeOut(125, function () {
						$('.animationText').val("");
					});

					$.post(`https://${GetParentResourceName()}/openSpawn`);
				}
				break;
		}
	});
})


