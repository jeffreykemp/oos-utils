create or replace package oos_util_string
as

  -- TYPES

  -- CONSTANTS
  /**
   * @constant gc_default_delimiter Default delimiter for delimited strings
   * @constant gc_cr Carriage Return
   * @constant gc_lf Line Feed
   * @constant gc_crlf Use for new lines.
   */
  gc_default_delimiter constant varchar2(1) := ',';
  gc_cr constant varchar2(1) := chr(13);
  gc_lf constant varchar2(1) := chr(10);
  gc_crlf constant varchar2(2) := gc_cr || gc_lf;

  function to_char(
    p_val in number)
    return varchar2
    deterministic;

  function to_char(
    p_val in date)
    return varchar2
    deterministic;

  function to_char(
    p_val in timestamp)
    return varchar2
    deterministic;

  function to_char(
    p_val in timestamp with time zone)
    return varchar2
    deterministic;

  function to_char(
    p_val in timestamp with local time zone)
    return varchar2;

  function to_char(
    p_val in boolean)
    return varchar2
    deterministic;

  function truncate(
    p_str in varchar2,
    p_length in pls_integer,
    p_by_word in varchar2 default 'N',
    p_ellipsis in varchar2 default '...')
    return varchar2;

  function sprintf(
    p_str in varchar2,
    p_s1 in varchar2 default null,
    p_s2 in varchar2 default null,
    p_s3 in varchar2 default null,
    p_s4 in varchar2 default null,
    p_s5 in varchar2 default null,
    p_s6 in varchar2 default null,
    p_s7 in varchar2 default null,
    p_s8 in varchar2 default null,
    p_s9 in varchar2 default null,
    p_s10 in varchar2 default null)
    return varchar2;

  function string_to_table(
    p_str in clob,
    p_delim in varchar2 default gc_default_delimiter)
    return oos_util.tab_vc2_arr;

  function string_to_table(
    p_str in varchar2,
    p_delim in varchar2 default gc_default_delimiter)
    return oos_util.tab_vc2_arr;

  function listunagg(
    p_str in varchar2,
    p_delim in varchar2 default gc_default_delimiter)
    return oos_util.tab_vc2 pipelined;

  function listunagg(
    p_str in clob,
    p_delim in varchar2 default gc_default_delimiter)
    return oos_util.tab_vc2 pipelined;

  function reverse(
    p_str in varchar2)
    return varchar2;

  function ordinal(
    p_num in number)
    return varchar2;

  /**
   * Tokenize a string.
   *
   * Notes:
   *  Intended as roughly equivalent to C/PHP's "strtok" function.
   *  On the first call, pass in the string to tokenize, and the delimiter.
   *  On subsequent calls, only pass in the next delimiter.
   *  Delimiter is mandatory. It may be a single character, or a string of
   *  alternative delimiter characters.
   *  Different delimiters may be passed on each call.
   *  Multiple adjacent delimiters in the string are treated as a single delimiter.
   *
   * @example
   *
   * Example 1
   *   strtok('hello world,, the sky says: hello',' ')     => 'hello'
   *   strtok(' ,')                                        => 'world'
   *   strtok(' ')                                         => 'the'
   *   strtok(':')                                         => 'sky says'
   *   strtok(':')                                         => 'hello'
   *   strtok(' ')                                         => ''
   *
   * Example 2
   *
        declare
          procedure parse_bible_ref (ref in varchar2) is
            book varchar2(100);
            chapter varchar2(100);
            verse varchar2(100);
          begin
            dbms_output.put_line('parse_bible_ref "' || ref || '"');
            book := str.strtok(ref, ' ');
            if lower(book) in ('1','2','3','i','ii','iii') then
              book := book || ' ' || str.strtok(' ');
            end if;
            dbms_output.put_line('book "' || book || '"');
            chapter := str.strtok(':');
            dbms_output.put_line('chapter "' || chapter || '"');
            loop
              verse := str.strtok(',');
              exit when verse is null;
              dbms_output.put_line('verse "' || verse || '"');
            end loop;
          end parse_bible_ref;
        begin
          parse_bible_ref('Genesis 1:1-12');
          parse_bible_ref('1 John 1:21');
          parse_bible_ref('Ezekiel 5');
          parse_bible_ref('II Chronicles 21:1,5-7');
        end;
   *
   * RESULT:
        parse_bible_ref "Genesis 1:1-12"
        book "Genesis"
        chapter "1"
        verse "1-12"
        parse_bible_ref "1 John 1:21"
        book "1 John"
        chapter "1"
        verse "21"
        parse_bible_ref "Ezekiel 5"
        book "Ezekiel"
        chapter "5"
        parse_bible_ref "II Chronicles 21:1,5-7"
        book "II Chronicles"
        chapter "21"
        verse "1"
        verse "5-7"
   *
   * @author Jeffrey Kemp
   * @created 03-Nov-2017
   * @param p_str string
   * @return token
   */
  function strtok (p_str in varchar2, p_delim in varchar2) return varchar2;
  function strtok (p_delim in varchar2) return varchar2;
  procedure strtok_reset_; -- clear the internal memory

end oos_util_string;
/
