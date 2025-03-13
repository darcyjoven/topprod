# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: p_gen4ad.4gl
# Descriptions...: 4ad / 4tm 檔背景產生作業
# Date & Author..: 08/11/28 alex
# Modify.........: FUN-A60023 10/07/01 By Kevin 檢查XML 保留字
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zz01          LIKE zz_file.zz01  
DEFINE   g_tm            LIKE type_file.chr1
 
MAIN
 
   LET g_zz01 = ARG_VAL(1)
   LET g_tm   = ARG_VAL(2)   #傳入 "Y" 做 4tm/4ad 傳入 "0" 做 4tm only
                             #不寫或其他  只做 4ad
   LET g_bgjob = "Y"
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   IF cl_null(g_zz01) THEN
      CALL p_gen4ad_msg()
      EXIT PROGRAM
   END IF
 
   IF g_tm <> "0" OR g_tm IS NULL THEN
      IF NOT p_gen4ad_4ad() THEN #產生 4ad 
         DISPLAY "Error: Generate ",g_zz01 CLIPPED,".4ad Fail!"
      END IF
   END IF
 
   IF UPSHIFT(g_tm) = "Y" OR g_tm = "0" THEN
      IF NOT p_gen4ad_4tm() THEN #產生 4tm 
         DISPLAY "Error: Generate ",g_zz01 CLIPPED,".4tm Fail!"
      END IF
   END IF
 
END MAIN
 
 
 
FUNCTION p_gen4ad_4ad()  # 重新產生 4ad by zz (because zz011)
 
   DEFINE ls_top         STRING
   DEFINE ls_topcust     STRING
   DEFINE lc_zz011       LIKE zz_file.zz011
   DEFINE ls_filename    STRING
   DEFINE ls_sql         STRING
   DEFINE ls_str         STRING
   DEFINE lc_gay01       LIKE gay_file.gay01
   DEFINE la_gbd         RECORD
             gbd01         LIKE gbd_file.gbd01,
             gbd04         LIKE gbd_file.gbd04,
             gbd05         LIKE gbd_file.gbd05
                         END RECORD
   DEFINE lc_gbd04       LIKE gbd_file.gbd04
   DEFINE lc_gbd05       LIKE gbd_file.gbd05
   DEFINE li_openhead    LIKE type_file.num5
   DEFINE li_cnt         LIKE type_file.num5
   DEFINE lc_channel     base.Channel
   DEFINE lr_log         STRING
   DEFINE lc_log         STRING
   DEFINE ls_text        STRING
 
   LET ls_top = os.Path.join(FGL_GETENV("TOP"),"config")
   LET ls_topcust = os.Path.join(FGL_GETENV("CUST"),"config")
 
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_zz01
   IF cl_null(lc_zz011) THEN
      RETURN FALSE
   END IF
 
   DECLARE p_mis_chk42_curl CURSOR FOR
    SELECT DISTINCT gay01 FROM gay_file ORDER BY gay01
   FOREACH p_mis_chk42_curl INTO lc_gay01
 
      LET lc_zz011 = DOWNSHIFT(lc_zz011)
      IF lc_zz011[1,1] = "c" THEN    #FUN-830022
         LET ls_filename = ls_topcust.trim() 
      ELSE
         LET ls_filename = ls_top.trim()
      END IF
      LET ls_filename = os.Path.join(os.Path.join(ls_filename,"4ad"),lc_gay01 CLIPPED)
      LET ls_filename = os.Path.join(os.Path.join(ls_filename,lc_zz011 CLIPPED),g_zz01 CLIPPED||".4ad")
 
      LET ls_str = "cat /dev/null 2>>$TEMPDIR/$(date +p_mis_log20%y%m%d.log) > ", ls_filename CLIPPED  #TQC-630006
      RUN ls_str
      LET li_openhead = FALSE
      LET ls_sql = " SELECT gap02,'','' FROM gap_file, gbd_file ",
                    " WHERE gap_file.gap01='",g_zz01 CLIPPED,"' ",
                      " AND gbd_file.gbd01=gap_file.gap02 ",
                      " AND gbd_file.gbd03='",lc_gay01 CLIPPED,"' ",
                      " AND gbd_file.gbd06 != 'Y' "
 
      PREPARE p_mis_chk43_pre FROM ls_sql           #預備一下
      DECLARE p_mis_chk43_curl CURSOR FOR p_mis_chk43_pre
 
      LET li_cnt = 0
      FOREACH p_mis_chk43_curl INTO la_gbd.*
         IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            CONTINUE FOREACH
         END IF
 
         #看一下有沒有standard的,標準的 
         SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file
          WHERE gbd_file.gbd01=la_gbd.gbd01
            AND gbd_file.gbd02='standard'
            AND gbd_file.gbd03=lc_gay01
            AND gbd_file.gbd07='N'
 
         IF NOT cl_null(lc_gbd04) THEN LET la_gbd.gbd04=lc_gbd04 CLIPPED END IF
         IF NOT cl_null(lc_gbd05) THEN LET la_gbd.gbd05=lc_gbd05 CLIPPED END IF
 
         #再看一下有沒有standard的,客製的 
         SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file
          WHERE gbd_file.gbd01=la_gbd.gbd01
            AND gbd_file.gbd02='standard'
            AND gbd_file.gbd03=lc_gay01
            AND gbd_file.gbd07='Y'
 
         IF NOT cl_null(lc_gbd04) THEN LET la_gbd.gbd04=lc_gbd04 CLIPPED END IF
         IF NOT cl_null(lc_gbd05) THEN LET la_gbd.gbd05=lc_gbd05 CLIPPED END IF
 
         #再看一下有沒有自設的,標準的 
         SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file
          WHERE gbd_file.gbd01=la_gbd.gbd01
            AND gbd_file.gbd02=g_zz01
            AND gbd_file.gbd03=lc_gay01
            AND gbd_file.gbd07='N'
 
         IF NOT cl_null(lc_gbd04) THEN LET la_gbd.gbd04=lc_gbd04 CLIPPED END IF
         IF NOT cl_null(lc_gbd05) THEN LET la_gbd.gbd05=lc_gbd05 CLIPPED END IF
 
         #再看一下有沒有自設的,客製的 
         SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file
          WHERE gbd_file.gbd01=la_gbd.gbd01
            AND gbd_file.gbd02=g_zz01
            AND gbd_file.gbd03=lc_gay01
            AND gbd_file.gbd07='Y'
 
         IF NOT cl_null(lc_gbd04) THEN LET la_gbd.gbd04=lc_gbd04 CLIPPED END IF
         IF NOT cl_null(lc_gbd05) THEN LET la_gbd.gbd05=lc_gbd05 CLIPPED END IF
 
         #FUN-A60023
         LET ls_text = la_gbd.gbd04      #檢查XML 保留字
         LET ls_text = cl_replace_multistr(ls_text, "<" , "&lt;")
         LET ls_text = cl_replace_multistr(ls_text, ">" , "&gt;")
         #看有沒有 comments 有就倒
         
         IF cl_null(la_gbd.gbd05) THEN
            LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" />"
         ELSE
            LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" comment=\"",la_gbd.gbd05 CLIPPED,"\" />"
         END IF
 
         IF li_openhead = FALSE THEN
            #輸出檔頭
            LET lc_channel = base.Channel.create()
            CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
            CALL lc_channel.setDelimiter("")
            CALL lc_channel.write("<?xml version='1.0'?>")
            CALL lc_channel.write("<ActionDefaultList>")
            LET li_openhead = TRUE
         END IF
 
         CALL lc_channel.write(ls_str)
         LET li_cnt = li_cnt + 1
 
      END FOREACH
 
      IF li_openhead = TRUE THEN
         CALL lc_channel.write("</ActionDefaultList>")
         CALL lc_channel.close()
         DISPLAY "SUCC: Info 4ad name = ",ls_filename 
      END IF
   END FOREACH
 
   IF li_cnt = 0 THEN
      DISPLAY "SUCC: ",g_zz01 CLIPPED," is no need to generate 4ad file!" 
   END IF
 
   RETURN TRUE
END FUNCTION
 
FUNCTION p_gen4ad_4tm()  # 重新產生 4tm by gap
 
   DEFINE ls_top         STRING
   DEFINE ls_topcust     STRING
   DEFINE lc_gap02       LIKE gap_file.gap02
   DEFINE lc_zz011       LIKE zz_file.zz011
   DEFINE ls_filename    STRING
   DEFINE ls_sql         STRING
   DEFINE ls_str         STRING
   DEFINE li_openhead    LIKE type_file.num5
   DEFINE li_cnt         LIKE type_file.num5
   DEFINE lc_channel     base.Channel
   DEFINE lr_log         STRING
   DEFINE lc_log         STRING
 
   LET ls_top = os.Path.join(FGL_GETENV("TOP"),"config")
   LET ls_topcust = os.Path.join(FGL_GETENV("CUST"),"config")
   LET li_cnt = 0
 
   SELECT zz011 INTO lc_zz011 FROM zz_file WHERE zz01=g_zz01
   IF cl_null(lc_zz011) THEN
      RETURN FALSE
   END IF
 
   LET lc_zz011 = DOWNSHIFT(lc_zz011)
   IF lc_zz011[1,1] = "c" THEN
      LET ls_filename = ls_topcust.trim()
   ELSE
      LET ls_filename = ls_top.trim()
   END IF
   LET ls_filename = os.Path.join(os.Path.join(ls_filename,"4tm"),lc_zz011 CLIPPED)
   LET ls_filename = os.Path.join(ls_filename,g_zz01 CLIPPED||".4tm")
 
   LET ls_str = "cat /dev/null 2>>$TEMPDIR/$(date +p_mis_log20%y%m%d.log) > ", ls_filename CLIPPED   #TQC-630006
   RUN ls_str
 
   LET li_openhead = FALSE
 
   LET ls_sql = " SELECT gap02 FROM gap_file ",
                 " WHERE gap01='",g_zz01 CLIPPED,"' ",
                   " AND gap05= 'Y' "
 
   PREPARE p_mis_chk52_pre FROM ls_sql
   DECLARE p_mis_chk52_curl CURSOR FOR p_mis_chk52_pre
   FOREACH p_mis_chk52_curl INTO lc_gap02
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
 
      LET ls_str = "    <TopMenuCommand name=\"",lc_gap02 CLIPPED,"\"/>"
 
      IF li_openhead = FALSE THEN
         #輸出檔頭
         LET lc_channel = base.Channel.create()
         CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
         CALL lc_channel.setDelimiter("")
 
         CALL lc_channel.write("<TopMenu>")
         CALL lc_channel.write("  <TopMenuGroup text=\"Extra\">")
         LET li_openhead = TRUE
      END IF
      CALL lc_channel.write(ls_str)
      LET li_cnt = li_cnt + 1
   END FOREACH
 
   IF li_openhead = TRUE THEN
      CALL lc_channel.write("  </TopMenuGroup>")
      CALL lc_channel.write("</TopMenu>")
      CALL lc_channel.close()
      DISPLAY "SUCC: Info 4tm name = ",ls_filename
   END IF
 
   IF li_cnt = 0 THEN
      DISPLAY "SUCC: ",g_zz01 CLIPPED," is no need to generate 4tm file!" 
   END IF
 
   RETURN TRUE
END FUNCTION
 
FUNCTION p_gen4ad_msg()
 
   DISPLAY "Usage:   exe2 p_gen4ad Program_ID [action_type]"
   DISPLAY ""
   DISPLAY "Example: exe2 p_gen4ad aooi030    Generate 4ad only"
   DISPLAY "         exe2 p_gen4ad aooi030 Y  Generate 4ad and 4tm"
   DISPLAY "         exe2 p_gen4ad aooi030 0  Generate 4tm only"
 
END FUNCTION
