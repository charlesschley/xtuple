CREATE OR REPLACE VIEW docinfo AS SELECT
  id,
  target_number,
  target_type,
  target_id,
  source_type_docinfo,
  source_id_docinfo,
  name,
  description,
  purpose,
  source_type,
  source_id
FROM (
  SELECT
    (unnest(_docinfo)).id,
    (unnest(_docinfo)).target_number,
    (unnest(_docinfo)).target_type,
    (unnest(_docinfo)).target_id,
    (unnest(_docinfo)).source_type AS source_type_docinfo,
    (unnest(_docinfo)).source_id AS source_id_docinfo,
    (unnest(_docinfo)).name,
    (unnest(_docinfo)).description,
    (unnest(_docinfo)).purpose,
    source_type,
    source_id
  FROM (
    SELECT DISTINCT
      *,
      ARRAY(SELECT _docinfo(docass_source_id, docass_source_type)) AS _docinfo
    FROM (
      SELECT
        docass_source_type,
        docass_source_id,
        docass_source_type AS source_type, -- Hack to pass docass_source_type to outer_wapper where clause
        docass_source_id AS source_id -- Hack to pass docass_source_id to outer_wapper where clause
      FROM docass
      UNION ALL
      SELECT
        imageass_source AS docass_source_type,
        imageass_source_id AS docass_source_id,
        imageass_source AS source_type, -- Hack to pass docass_source_type to outer_wapper where clause
        imageass_source_id AS source_id -- Hack to pass docass_source_id to outer_wapper where clause
      FROM imageass
      UNION ALL
      SELECT
        url_source AS docass_source_type,
        url_source_id AS docass_source_id,
        url_source AS source_type, -- Hack to pass docass_source_type to outer_wapper where clause
        url_source_id AS source_id -- Hack to pass docass_source_id to outer_wapper where clause
      FROM url
    ) AS docinfo
  ) AS inner_wrapper
) AS outer_wrapper;

REVOKE ALL ON TABLE docinfo FROM PUBLIC;
GRANT  ALL ON TABLE docinfo TO GROUP xtrole;
