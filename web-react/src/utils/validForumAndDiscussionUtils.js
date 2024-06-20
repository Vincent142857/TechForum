const badWords = ["badword1", "badword2", "badword3"];

export const validateTitle = (title, existing) => {
	if (!title.trim()) {
		return "Title is required";
	}

	const isDuplicate = existing.some((group) => group.title === title);
	if (isDuplicate) {
		return "Title already in use";
	}

	const containsBadWords = badWords.some((badWord) =>
		title.toLowerCase().includes(badWord)
	);
	if (containsBadWords) {
		return "Title contains inappropriate language";
	}

	return "";
};
export const validateLabel = (label, existing) => {
	if (!label.trim()) {
		return "Label is required";
	}

	const isDuplicate = existing.some((group) => group.label === label);
	if (isDuplicate) {
		return "Label already in use";
	}

	const containsBadWords = badWords.some((badWord) =>
		label.toLowerCase().includes(badWord)
	);
	if (containsBadWords) {
		return "Title contains inappropriate language";
	}

	return "";
};

export const validateIcon = (icon) => {
	if (!icon.trim()) {
		return "Icon is required";
	}

	return "";
};

export const validateColor = (color) => {
	if (!color.trim() || color === "#ffffff") {
		return "Color is required";
	}

	return "";
};

export const validateDescription = (description, existing) => {
	if (!description.trim()) {
		return "Description is required";
	}

	if (description === "<p><br></p>") {
		return "Description is required";
	}

	const isDuplicate = existing.some(
		(group) => group.description === description
	);
	if (isDuplicate) {
		return "Description already in use";
	}

	const containsBadWords = badWords.some((badWord) =>
		description.toLowerCase().includes(badWord)
	);
	if (containsBadWords) {
		return "Title contains inappropriate language";
	}

	return "";
};

export const validateContentDiscussion = (content, existing) => {
	if (!content.trim()) {
		return "Content is required";
	}

	if (content === "<p><br></p>") {
		return "Content is required";
	}

	const isDuplicate = existing.some((group) =>
		group.comments?.some((comment) => comment.content === content)
	);
	if (isDuplicate) {
		return "Content already in use";
	}

	const containsBadWords = badWords.some((badWord) =>
		content.toLowerCase().includes(badWord)
	);
	if (containsBadWords) {
		return "Title contains inappropriate language";
	}

	return "";
};

export const validateContent = (content, existing) => {
	if (!content.trim()) {
		return "Content is required";
	}

	if (content === "<p><br></p>") {
		return "Content is required";
	}

	const isDuplicate = existing.some((group) => group.content === content);
	if (isDuplicate) {
		return "Content already in use";
	}

	const containsBadWords = badWords.some((badWord) =>
		content.toLowerCase().includes(badWord)
	);
	if (containsBadWords) {
		return "Title contains inappropriate language";
	}

	return "";
};
