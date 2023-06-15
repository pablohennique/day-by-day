json.form render(
  partial: "entries/entries_cards",
  formats: :html,
  locals: { entries: @entries } )

# json.inserted_item render(partial: "entries/entries_cards", formats: :html, locals: {entreis: @entries})
