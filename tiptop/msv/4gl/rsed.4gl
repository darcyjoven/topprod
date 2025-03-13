# Prog. Version..: '5.00.02-07.06.21(00000)'     #
#
# Pattern name...: rsed.4gl
# Descriptions...: 
# Input parameter: None
# Return code....: None
# Date & Author..: 
# Modify.........: 

IMPORT os

MAIN

    DEFINE ls_source     STRING
    DEFINE ls_dist       STRING
    DEFINE lp_source     base.Channel
    DEFINE lp_dist       base.Channel

    DEFINE ls_target     STRING
    DEFINE ls_replace    STRING
#   DEFINE lc_analy      CHAR(200)
    DEFINE ls_analy      STRING
    DEFINE li_i          SMALLINT

    LET ls_target = ARG_VAL(1)
    LET ls_replace= ARG_VAL(2)
    LET ls_source = ARG_VAL(3)
    LET ls_dist   = ARG_VAL(4)

    IF ls_source.trim()  IS NULL OR ls_source.trim()  = "" OR
       ls_dist.trim()    IS NULL OR ls_dist.trim()    = "" OR
       ls_target.trim()  IS NULL OR ls_target.trim()  = "" OR
       ls_replace.trim() IS NULL OR ls_replace.trim() = "" THEN
       EXIT PROGRAM
    END IF

    #因應安全機制設計,需先檢查,若不存在則跳過此作業
    IF NOT os.Path.exists(ls_source.trim()) THEN
       EXIT PROGRAM
    END IF
    IF os.Path.exists(ls_dist.trim()) THEN
       IF NOT os.Path.delete(ls_dist.trim()) THEN
          EXIT PROGRAM
       END IF
    END IF

    LET lp_source = base.Channel.create()
    LET lp_dist   = base.Channel.create()

    CALL lp_source.openFile(ls_source.trim(),"r")
    CALL lp_dist.openFile(ls_dist.trim(),"a")
    CALL lp_dist.setDelimiter("")

    WHILE lp_source.read([ls_analy])
#      LET ls_analy = lc_analy CLIPPED
       LET ls_analy = ls_analy CLIPPED

       CALL ls_analy.getIndexOf(ls_target,1) RETURNING li_i
       CASE
          WHEN li_i > 1 
            IF (li_i + ls_target.getLength() >= ls_analy.getLength()) THEN
               LET ls_analy = ls_analy.subString(1,li_i-1),
                              ls_replace.trim()
            ELSE
               LET ls_analy = ls_analy.subString(1,li_i-1),
                              ls_replace.trim(),
                              ls_analy.subString(li_i + ls_target.getLength(),
                                                 ls_analy.getLength())
            END IF
          WHEN li_i = 1 
            IF (li_i + ls_target.getLength() >= ls_analy.getLength()) THEN
               LET ls_analy = ls_replace.trim()
            ELSE
               LET ls_analy = ls_replace.trim(),
                              ls_analy.subString(li_i + ls_target.getLength(),
                                                 ls_analy.getLength())
            END IF
       END CASE
       CALL lp_dist.write(ls_analy)

    END WHILE
    CALL lp_source.close()
    CALL lp_dist.close()

END MAIN


