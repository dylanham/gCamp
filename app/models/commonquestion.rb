
class CommonQuestion

  def Initialize(question,answer)
    @question = question
    @answer = answer
    @slug = question.downcase.strip.gsub(" ","-")
  end

  def show_question
    @question
  end

  def show_answer
    @answer
  end

  def show_slug
    @slug
  end

end


first = CommonQuestion.new("What is gCamp?",
"gCamp is an awesome tool that is going to change your life.
 gCamp is your one stop shop to organize all your tasks.
 You'll also be able to track comments that you and others make.
 gCamp may eventually replace all need for paper and pens in the entire world.
 Well, maybe not, but it's going to be pretty cool.")
second = CommonQuestion.new("How do I join gCamp?",
"As soon as it's ready for the public, you'll see a signup link in the upper right.
Once that's there, just click it and fill in the form!")
third = CommonQuestion.new("When will gCamp be finished?",
"gCamp is a work in progress.
That being said, it should be fully functional in the next few weeks.
Functional. Check in daily for new features and awesome functionality.
It's going to blow your mind. Organization is just a click away. Amazing!")
@first_question  = first.show_question
@second_question = second.show_question
@third_question  = third.show_question

@first_answer    = first.show_answer
@second_answer   = second.show_answer
@third_answer    = third.show_answer

@first_slug      = first.show_slug
@second_slug     = second.show_slug
@third_slug      = third.show_slug
