alter table lesson_step_translations
    alter column content type jsonb
        using jsonb_build_object(
            'blocks',
            jsonb_build_array(
                    jsonb_build_object(
                            'type', 'paragraph',
                            'text', content
                    )
            )
              );