DATABASE ds

GLOBALS "../../config/top.global" 

FUNCTION s_infor(fn,p_cmd)
  DEFINE p_cmd LIKE type_file.chr1
  DEFINE fn STRING
  DEFINE txt STRING
  OPEN WINDOW show_w WITH FORM "ghr/42f/s_infor"
     ATTRIBUTE(TEXT="Infor",STYLE="dialog")
  CASE p_cmd 
     WHEN 's'
        LET txt = fn
     WHEN 'f'
        LET txt = readfile(fn)
  END CASE
  INPUT BY NAME txt WITHOUT DEFAULTS
  LET int_flag=FALSE
  CLOSE WINDOW show_w
END FUNCTION

FUNCTION readfile(fn)
  DEFINE fn STRING
  DEFINE txt STRING
  DEFINE ln STRING
  DEFINE ch base.Channel
  LET ch=base.Channel.create()
  CALL ch.openfile(fn,"r")
  CALL ch.setDelimiter("")
  WHILE ch.read(ln)
    IF txt IS NULL THEN
      IF ln IS NULL THEN
        LET txt = "\n"
      else
        LET txt = ln
      END IF
    ELSE
      IF ln IS NULL THEN
        LET txt = txt || "\n"
      ELSE
        LET txt = txt || "\n" || ln
      END IF
    END IF
  END WHILE
  CALL ch.close()
  RETURN txt
END FUNCTION


