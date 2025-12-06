return {
	Name = "Dark",
	Accent = Color3.fromRGB(255, 255, 255), -- ให้สีเน้นเป็นขาวด้วย

	AcrylicMain = Color3.fromRGB(0, 0, 0), -- ดำสนิท
	AcrylicBorder = Color3.fromRGB(255, 255, 255), -- ขอบขาว
	AcrylicGradient = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)),
	AcrylicNoise = 0.9,

	TitleBarLine = Color3.fromRGB(255, 255, 255), -- เส้นขาว
	Tab = Color3.fromRGB(20, 20, 20),

	Element = Color3.fromRGB(15, 15, 15), -- กล่องดำสนิท
	ElementBorder = Color3.fromRGB(255, 255, 255), -- ขอบขาว
	InElementBorder = Color3.fromRGB(255, 255, 255),
	ElementTransparency = 0.87,

	ToggleSlider = Color3.fromRGB(30, 30, 30),
	ToggleToggled = Color3.fromRGB(255, 255, 255), -- เปิดเป็นไอคอนสีขาว

	SliderRail = Color3.fromRGB(40, 40, 40),

	DropdownFrame = Color3.fromRGB(20, 20, 20),
	DropdownHolder = Color3.fromRGB(0, 0, 0),
	DropdownBorder = Color3.fromRGB(255, 255, 255), -- ขอบขาว
	DropdownOption = Color3.fromRGB(30, 30, 30),

	Keybind = Color3.fromRGB(25, 25, 25),

	Input = Color3.fromRGB(30, 30, 30),
	InputFocused = Color3.fromRGB(0, 0, 0),
	InputIndicator = Color3.fromRGB(255, 255, 255),

	Dialog = Color3.fromRGB(0, 0, 0),
	DialogHolder = Color3.fromRGB(0, 0, 0),
	DialogHolderLine = Color3.fromRGB(255, 255, 255),
	DialogButton = Color3.fromRGB(20, 20, 20),
	DialogButtonBorder = Color3.fromRGB(255, 255, 255),
	DialogBorder = Color3.fromRGB(255, 255, 255),
	DialogInput = Color3.fromRGB(20, 20, 20),
	DialogInputLine = Color3.fromRGB(255, 255, 255),

	Text = Color3.fromRGB(255, 255, 255), -- ตัวอักษรสีขาวชัด
	SubText = Color3.fromRGB(200, 200, 200),
	Hover = Color3.fromRGB(40, 40, 40),
	HoverChange = 0.07,
}
