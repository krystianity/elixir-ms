# this is just an example scheme of how a kafka json message could look like
# you might want to adapt this
defmodule ExTest.KafkaMessage do
  @derive [Poison.Encoder]
  defstruct [
    :id,
    :payload,
    :key,
    :time,
    :type
  ]
end

defmodule ExTest.KafkaConsumer do
  use KafkaConsumer.EventHandler

     @moduledoc """
     A Kafka Consumer Demo
     """

  alias MSBase.Log

  def handle_call({topic, partition, message}, _from, state) do

    try do
        Log.debug "kafka msg: #{topic}:#{partition} message: #{message.key}"
        msg = Poison.decode!(message.value, as: %ExTest.KafkaMessage{})
        Log.info msg.payload
        :ok
    rescue
        e in RuntimeError -> e
        Log.error to_string(e)
    end

    {:reply, :ok, state}
  end

  # returns stats
  def get_stats(topic) when is_binary(topic) do
    KafkaEx.metadata(topic: topic)
  end

  def get_stats do
      topic = Application.get_env(:ex_test, :kafka_topic)
      get_stats topic
    end

  # returns a list of all partition ids for a given topic
  def get_partition_list(topic) do
    kafka_md = get_stats topic
    topic_md = List.first kafka_md.topic_metadatas
    part_md = topic_md.partition_metadatas
    Enum.map(part_md, fn(p) -> p.partition_id end)
  end

  # a list of all partitions of this topic
  # can be used to set config.exs easier
  def get_partition_config(topic) do
    partitions = get_partition_list topic
    Enum.map(partitions, fn(p) -> {topic, p} end)
  end

end
