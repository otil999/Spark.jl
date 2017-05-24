lines = text_file(sc, "s3://dataworld-linked-acs/Ontology/PUMA.ttl")
line_count = count(lines)

@test line_count == 23566
