require "test_helper"
require "stringio"

class ServiceTest < ActiveSupport::TestCase
  test "persists all nested faqs on create" do
    service = build_service(
      service_faqs_attributes: {
        "0" => { question: "Q1", answer: "A1" },
        "1" => { question: "Q2", answer: "A2" }
      }
    )

    assert_difference("ServiceFaq.count", 2) do
      assert service.save
    end

    assert_equal 2, service.service_faqs.size
  end

  test "persists all nested faqs on update" do
    service = build_service
    service.service_faqs.build(question: "Q1", answer: "A1")
    service.save!

    attrs = {
      service_faqs_attributes: {
        "0" => { id: service.service_faqs.first.id, question: "Q1 edit", answer: "A1 edit" },
        "1" => { question: "Q2", answer: "A2" }
      }
    }

    assert_difference("ServiceFaq.count", 1) do
      assert service.update(attrs)
    end

    assert_equal 2, service.service_faqs.reload.count
    assert_equal [ "Q1 edit", "Q2" ], service.service_faqs.order(:id).pluck(:question)
  end

  private

  def build_service(attributes = {})
    service = Service.new(
      {
        name: "Servico teste",
        description: "Descricao teste"
      }.merge(attributes)
    )

    service.details = "Detalhes do servico"
    service.image.attach(
      io: StringIO.new("fake image"),
      filename: "service.jpg",
      content_type: "image/jpeg"
    )

    service
  end
end
