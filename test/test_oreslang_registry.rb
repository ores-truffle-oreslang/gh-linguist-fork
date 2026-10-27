require_relative "./helper"

class TestOreslangRegistry < Minitest::Test
  include Linguist

  def test_ores_extension_and_alias_are_registered_without_colliding_with_rust
    language = Language["Oreslang"]
    refute_nil language
    assert_includes language.extensions, ".ores"
    assert_includes Language.find_by_extension(".ores"), language
    refute_includes Language.find_by_extension(".rs"), language
    assert_equal "source.oreslang", language.tm_scope
  end

  def test_oreslang_samples_exercise_distinct_lexical_shapes
    root = File.expand_path("../samples/Oreslang", __dir__)
    files = %w[cli_main.ores web_index.ores contract_shapes.ores]
    files.each do |file|
      path = File.join(root, file)
      assert File.file?(path), "Missing Oreslang sample: #{file}"
      assert File.read(path, encoding: "UTF-8").valid_encoding?
    end
    assert_match(/\bfnc\b/, File.read(File.join(root, "web_index.ores")))
    assert_match(/\bpub\b/, File.read(File.join(root, "cli_main.ores")))
    contract = File.read(File.join(root, "contract_shapes.ores"))
    assert_match(/\bOption\b/, contract)
    assert_match(/\bactor\b/, contract)
    assert_match(/\bawait\b/, contract)
  end
end
