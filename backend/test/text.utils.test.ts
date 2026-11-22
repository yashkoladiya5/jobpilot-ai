import test, { describe, it } from "node:test";
import assert from "node:assert/strict";
import { countWords, splitSentences, termFrequency, averageSentenceLength } from "../src/utils/text";

describe("Text Utilities Unit Tests", () => {
  it("countWords correctly counts words and handles whitespace", () => {
    assert.equal(countWords(""), 0);
    assert.equal(countWords("   "), 0);
    assert.equal(countWords("Hello world"), 2);
    assert.equal(countWords("  Senior  Flutter   Engineer  "), 3);
  });

  it("splitSentences splits text into non-empty trimmed sentences", () => {
    const text = "Experienced engineer. Skilled in Dart and Node! Are you hiring?";
    const sentences = splitSentences(text);
    assert.equal(sentences.length, 3);
    assert.equal(sentences[0], "Experienced engineer.");
    assert.equal(sentences[1], "Skilled in Dart and Node!");
    assert.equal(sentences[2], "Are you hiring?");
  });

  it("termFrequency ignores stop words and returns descending frequency", () => {
    const sample = "Flutter developer with Flutter experience and Dart knowledge Flutter";
    const frequencies = termFrequency(sample, 5);
    assert.ok(frequencies.length > 0);
    assert.equal(frequencies[0].term, "flutter");
    assert.equal(frequencies[0].count, 3);
  });

  it("averageSentenceLength calculates average words per sentence", () => {
    const text = "One two three four. Five six.";
    const avg = averageSentenceLength(text);
    assert.equal(avg, 3);
  });
});
