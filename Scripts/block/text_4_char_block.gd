extends Node3D

const VALID_PASSWORDS = [
	"ABOUT", "AFTER", "AGAIN", "BELOW", "COULD",
	"EVERY", "FIRST", "FOUND", "GREAT", "HOUSE",
	"LARGE", "LEARN", "NEVER", "OTHER", "PLACE",
	"PLANT", "POINT", "RIGHT", "SMALL", "SOUND",
	"SPELL", "STILL", "STUDY", "THEIR", "THERE",
	"THESE", "THING", "THINK", "THREE", "WATER",
	"WHERE", "WHICH", "WORLD", "WOULD", "WRITE"
]

var solution = ""
var letter_options = []        # Array of 5 arrays, each with 6 letters
var current_indices = [0, 0, 0, 0, 0]

var finish := false
var correct := false

func _ready() -> void:
	randomize()
	generate_puzzle()
	update_display()

func _process(_delta: float) -> void:
	# Character cycling per slot
	change_char(%char_1, $char_1_up_button, $char_1_down_button, 0)
	change_char(%char_2, $char_2_up_button, $char_2_down_button, 1)
	change_char(%char_3, $char_3_up_button, $char_3_down_button, 2)
	change_char(%char_4, $char_4_up_button, $char_4_down_button, 3)
	change_char(%char_5, $char_5_up_button, $char_5_down_button, 4)

	# Construct guess from selected characters
	var guess := ""
	for i in range(5):
		guess += letter_options[i][current_indices[i]]

	correct = guess == solution

	# Detect push button press (rising edge)
	if %push_button.is_pressed and not %push_button.last_pressed:
		finish = true
		%push_button.last_pressed = true
		%state.finish = finish
		%state.correct = correct


func generate_puzzle():
	solution = VALID_PASSWORDS[randi() % VALID_PASSWORDS.size()]
	letter_options.clear()

	for i in range(5):
		var letters := []
		var correct_letter = solution[i]
		letters.append(correct_letter)

		while letters.size() < 6:
			var rand_letter := char("A".unicode_at(0) + randi() % 26)
			if rand_letter not in letters:
				letters.append(rand_letter)

		letters.shuffle()
		letter_options.append(letters)
		current_indices[i] = randi() % 6
	
	print("PASSWORD: " + str(solution))
	print("Each letter character option" + str(letter_options))

func cycle_up(position: int):
	current_indices[position] = (current_indices[position] + 1) % 6

func cycle_down(position: int):
	current_indices[position] = (current_indices[position] - 1 + 6) % 6

func change_char(char_node: Node, up_button: Node, down_button: Node, position: int) -> void:
	var char_label = char_node.get_node("Character")

	if up_button.is_pressed and not up_button.last_pressed:
		cycle_up(position)
		char_label.text = letter_options[position][current_indices[position]]

	elif down_button.is_pressed and not down_button.last_pressed:
		cycle_down(position)
		char_label.text = letter_options[position][current_indices[position]]

	up_button.last_pressed = up_button.is_pressed
	down_button.last_pressed = down_button.is_pressed

func update_display():
	%char_1/Character.text = letter_options[0][current_indices[0]]
	%char_2/Character.text = letter_options[1][current_indices[1]]
	%char_3/Character.text = letter_options[2][current_indices[2]]
	%char_4/Character.text = letter_options[3][current_indices[3]]
	%char_5/Character.text = letter_options[4][current_indices[4]]
