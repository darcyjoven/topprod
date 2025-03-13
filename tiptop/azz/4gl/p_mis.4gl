# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: p_mis.4gl
# Descriptions...: 系統資料重整作業
# Date & Author..: 05/01/14 alex
# Modify.........: No.MOD-530409 05/03/29 By alex 修正 zz->gak,gap
# Modify.........: No.MOD-560015 05/06/02 By alex 取消 gap06 = "Y" 設定
# Modify.........: No.FUN-570096 05/07/11 By alex 新增全系統 p_get_zr 作業
# Modify.........: No.TQC-630006 06/03/02 By alex 移除 cat /dev/null 寫法
# Modify.........: No.FUN-6A0096 06/10/27 By johnray l_time改為g_time
# Modify.........: No.FUN-7B0028 07/11/12 By alex 增加抓取 lib/sub 說明資料
# Modify.........: No.FUN-7B0112 07/11/26 By alex 新增完成後提示視窗
# Modify.........: No.FUN-830022 08/03/05 By alex 新增依zx資料產生4sm功能(同p_zx產生4sm功能)
# Modify.........: No.FUN-850036 08/05/09 By alex 修改 open window代碼
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No.FUN-A60023 10/07/01 By Kevin 檢查XML 保留字
# Modify.........: No.FUN-AB0041 10/11/10 By Kevin 新增ASE程式段,調整抓gbd方法
# Modify.........: No.TQC-B60011 11/06/02 By alex 效能調整作業
# Modify.........: No.FUN-C10004 12/02/06 By tsai_yen GP5.3 GWC&GDC開發區合併
 
IMPORT os
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_zz01          LIKE zz_file.zz01    # 類別代號 (假單頭)
DEFINE   g_zz01_t        LIKE zz_file.zz01    # 類別代號 (假單頭)
DEFINE   g_rm            STRING
DEFINE   g_mis           RECORD
           chk1          LIKE type_file.chr1,
           chk2          LIKE type_file.chr1,
           chk3          LIKE type_file.chr1,
           chk4          LIKE type_file.chr1,
           chk5          LIKE type_file.chr1,
           chk6          LIKE type_file.chr1,
           chk7          LIKE type_file.chr1,             # FUN-570096
           chk8          LIKE type_file.chr1,             # FUN-7B0028
           chk9          LIKE type_file.chr1              # FUN-830022
                     END RECORD
MAIN
 
   OPTIONS                                        # 改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                                # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AZZ")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   OPEN WINDOW p_mis_w WITH FORM "azz/42f/p_mis"      #FUN-850036
   ATTRIBUTE(STYLE=g_win_style CLIPPED)
    
   CALL cl_ui_init()   
   
   CALL p_mis_menu()
 
   CLOSE WINDOW p_mis_w                       # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
 
FUNCTION p_mis_menu()
 
   DEFINE li_exit    LIKE type_file.num5
   DEFINE li_finish  LIKE type_file.num5   #FUN-7B0112
 
   WHILE TRUE
 
   LET g_mis.chk1="N"
   LET g_mis.chk2="N"
   LET g_mis.chk3="N"
   LET g_mis.chk4="N"
   LET g_mis.chk5="N"
   LET g_mis.chk6="N"
   LET g_mis.chk7="N"          #FUN-570096
   LET g_mis.chk8="N"          #FUN-7B0028
   LET g_mis.chk9="N"          #FUN-830022
   LET li_exit = FALSE
   LET li_finish = 0       #FUN-7B0112
 
   INPUT BY NAME g_mis.* WITHOUT DEFAULTS
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION locale
         CALL cl_dynamic_locale() 
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
       ON ACTION controlg      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION exit
         LET li_exit = TRUE
         EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG OR li_exit THEN
      LET INT_FLAG = 0
      EXIT WHILE
   END IF
 
   #FUN-7B0112
   IF g_mis.chk1 = "Y" THEN CALL p_mis_chk1() LET li_finish = 1 END IF  # 重抓 gap 資料
   IF g_mis.chk2 = "Y" THEN CALL p_mis_chk2() LET li_finish = 1 END IF  # 將 gap 資料導入 zz04
   IF g_mis.chk3 = "Y" THEN CALL p_mis_chk3() LET li_finish = 1 END IF  # 將 zz04 資料導入 zy03
   IF g_mis.chk4 = "Y" AND g_mis.chk5 = "Y" THEN
      LET g_rm = "rm $TEMPDIR/p_mis_log20*.log"
      RUN g_rm
      CALL p_mis_chk4()
      CALL p_mis_chk5()
      LET li_finish = 1
      CALL cl_cmdrun("p_mis_msg")
   ELSE
      IF g_mis.chk4 = "Y" AND g_mis.chk5 = "N"  THEN
         LET g_rm = "rm $TEMPDIR/p_mis_log20*.log"
         RUN g_rm
         CALL p_mis_chk4()
         LET li_finish = 1
         CALL cl_cmdrun("p_mis_msg")
      END IF  # 重新產生 4ad
      IF g_mis.chk5 = "Y" AND g_mis.chk4 = "N" THEN
         LET g_rm ="rm $TEMPDIR/p_mis_log20*.log"
         RUN g_rm
         CALL p_mis_chk5()
         LET li_finish = 1
         CALL cl_cmdrun("p_mis_msg")
      END IF  # 重新產生 4tm
   END IF
   IF g_mis.chk6 = "Y" THEN CALL p_mis_chk6() LET li_finish = 1 END IF  # 重新產生 help
   IF g_mis.chk7 = "Y" THEN CALL p_mis_chk7() LET li_finish = 1 END IF  # 重新抓取 p_zr FUN-570096
   IF g_mis.chk8 = "Y" THEN CALL p_mis_chk8() LET li_finish = 1 END IF  # 重新抓取 p_get_lib FUN-7B0028
   IF g_mis.chk9 = "Y" THEN CALL p_mis_chk9() LET li_finish = 1 END IF  # 重新產生 4sm  FUN-830022
 
   IF li_finish THEN
      CALL cl_err(NULL,"lib-022",1)
   END IF
 
   END WHILE
 
END FUNCTION
 
FUNCTION p_mis_chk1()   # 重抓 gap 資料
   DEFINE lc_gak01  LIKE gak_file.gak01
   DEFINE l_cmd     STRING
   DEFINE l_sql     STRING                #FUN-C10004
   DEFINE l_zz011   LIKE zz_file.zz011    #模組代碼   #FUN-C10004

   LET l_sql = "SELECT zz011 FROM zz_file WHERE zz01=?"   #取模組   #FUN-C10004
   PREPARE p_mis_sys_pre FROM l_sql                                #FUN-C10004
   
   DECLARE p_mis_chk1_curl CURSOR FOR
      SELECT DISTINCT gak01 FROM gak_file ORDER BY gak01           #FUN-C10004
      #SELECT UNIQUE gak01 FROM gak_file WHERE 1=1 ORDER BY gak01  #FUN-C10004 mark   
   
   FOREACH p_mis_chk1_curl INTO lc_gak01
      EXECUTE p_mis_sys_pre USING lc_gak01 INTO l_zz011            #FUN-C10004
      #IF lc_gak01[1]="a" OR lc_gak01[1]="p" OR lc_gak01[1]="u" OR #FUN-C10004 mark
      #是要先在WEB區執行p_webmis,不在此掃描WEB模組4gl的action
      IF (l_zz011[1]!="W" AND l_zz011[1,2]!="CW") AND   #WEB模組不做  #FUN-C10004
         (lc_gak01[1]="a" OR lc_gak01[1]="p" OR lc_gak01[1]="u" OR #FUN-C10004 add "("
          lc_gak01[1]="g" OR lc_gak01[1]="c") THEN                 #FUN-C10004 add ")"
 
         LET l_cmd = "p_get_act '" || lc_gak01 CLIPPED || "' "
         DISPLAY l_cmd
         CALL cl_cmdrun_unset_lang_wait(l_cmd)
 
      END IF
   END FOREACH

   CLOSE p_mis_chk1_curl
   FREE p_mis_chk1_curl

   RETURN
END FUNCTION
 
FUNCTION p_mis_chk2()  # 將 gap 資料導入 zz04
 
   DEFINE lc_zz01     LIKE zz_file.zz01
   DEFINE lc_zz04     LIKE zz_file.zz04
   DEFINE lc_zz08     LIKE zz_file.zz08
   DEFINE lc_gap01    LIKE gap_file.gap01
   DEFINE li_upd      LIKE type_file.num5
   DEFINE ls_sql      STRING
   DEFINE lc_gap02    LIKE gap_file.gap02
   DEFINE lsb_act     base.StringBuffer
 
  LET li_upd=0
  LET lsb_act = base.StringBuffer.create()

  LET ls_sql=" SELECT gap02 FROM gap_file WHERE gap01 = ? ORDER BY gap02 "
  DECLARE p_mis_chk21_curl CURSOR FROM ls_sql

  # 2004/08/17 逐隻抓取 zz01 並組出 gap_file 相關資料
  DECLARE p_mis_chk2_curl CURSOR FOR
     SELECT zz01,zz08 FROM zz_file
      WHERE zz08[1,9]='$FGLRUN $' ORDER BY zz01

  FOREACH p_mis_chk2_curl INTO lc_zz01,lc_zz08
 
     IF SQLCA.SQLCODE THEN
        ERROR lc_zz01 CLIPPED,"Generating Error:",SQLCA.sqlcode
     ELSE
        #MOD-530409
        LET ls_sql=lc_zz08 CLIPPED
        LET ls_sql=ls_sql.subString(ls_sql.getIndexOf("$FGLRUN $",1)+9,ls_sql.getLength())
        LET ls_sql=ls_sql.subString(ls_sql.getIndexOf("/",1)+1,ls_sql.getLength())
        IF ls_sql.getIndexOf(" ",1) THEN
           LET lc_gap01=ls_sql.substring(1,ls_sql.getIndexOf(" ",1))
        ELSE
           LET lc_gap01=ls_sql.trim()
        END IF
        
        # 2004/07/27 只做 gap_file 中 "p" "a" "g" "c" "u" 開頭的
        #IF lc_gap01[1]!="p" AND lc_gap01[1]!="a" AND lc_gap01[1]!="g" AND
        IF lc_gap01[1]!="p" AND lc_gap01[1]!="a" AND lc_gap01[1]!="g" AND
           lc_gap01[1]!="c" AND lc_gap01[1]!="u" AND  #FUN-C10004 add "AND"
           lc_gap01[1]!="w" THEN                      #WEB模組的程式  #FUN-C10004
           CONTINUE FOREACH
        END IF
 
        # 2004/08/17 符合條件的開始抓 gap_file 的 action_id
        CALL lsb_act.clear()

#       LET ls_sql=" SELECT gap02 FROM gap_file WHERE gap01='",lc_gap01 CLIPPED,"' ORDER BY gap02 "
#       DECLARE p_mis_chk21_curl CURSOR FROM ls_sql
#       FOREACH p_mis_chk21_curl INTO lc_gap02

        FOREACH p_mis_chk21_curl USING lc_gap01 INTO lc_gap02
           IF SQLCA.SQLCODE THEN
              ERROR lc_zz01 CLIPPED,"Generating Error:",SQLCA.sqlcode
           ELSE
              IF (lsb_act.getLength() = 0) THEN
                 CALL lsb_act.append(lc_gap02 CLIPPED)
              ELSE
                 CALL lsb_act.append(", " || lc_gap02 CLIPPED)
              END IF
           END IF
        END FOREACH
 
        # 2004/08/17 如果抓取成功  則更新 zz04
        IF lsb_act.getLength() !=0 THEN
           LET lc_zz04 = lsb_act.toString()
           display 'prog id=',lc_zz01 CLIPPED,' id=',lc_zz04
           UPDATE zz_file SET zz04=lc_zz04
            WHERE zz01=lc_zz01
           LET li_upd=li_upd+1
        ELSE
           display 'prog id=',lc_zz01 CLIPPED,' is empty in gap!'
        END IF
 
     END IF
  END FOREACH

  CLOSE p_mis_chk2_curl
  CLOSE p_mis_chk21_curl
  FREE p_mis_chk2_curl
  FREE p_mis_chk21_curl
 
  DISPLAY " Succeesful! Total Update:",li_upd," Rows"
 
  RETURN
END FUNCTION
 
FUNCTION p_mis_chk3()  # 將 zz04 資料導入 zy03
 
   DEFINE lc_mis     LIKE zx_file.zx01
   DEFINE lc_misclas LIKE zx_file.zx04        #mis群組類別
   DEFINE lc_zy03    LIKE zy_file.zy03        #權限種類
   DEFINE lc_zz01    LIKE zz_file.zz01
   DEFINE li_count   LIKE type_file.num5
   DEFINE li_zycount LIKE type_file.num5
   DEFINE lc_ans     LIKE type_file.chr1               # answer
   DEFINE ls_msg01   STRING
   DEFINE ls_msg02   STRING
   DEFINE li_upd     LIKE type_file.num5
   DEFINE li_ins     LIKE type_file.num5
 
   LET li_upd = 0
   LET li_ins = 0
   DECLARE p_mis_chk3_curl CURSOR FOR
      SELECT zz01,zz04 FROM zz_file WHERE 1=1 ORDER BY zz01
   FOREACH p_mis_chk3_curl INTO lc_zz01,lc_zy03
 
      IF SQLCA.SQLCODE THEN
         ERROR "Generating Error:",SQLCA.sqlcode
      ELSE
         # 2004/07/27 只做 zz_file 中 "p" "a" "g" "c" "u" 開頭的
         IF lc_zz01[1]!="p" AND lc_zz01[1]!="a" AND lc_zz01[1]!="g" AND
            lc_zz01[1]!="c" AND lc_zz01[1]!="u" AND #FUN-C10004 add "AND"
            lc_zz01[1]!="w" THEN      #WEB模組的程式  #FUN-C10004
            CONTINUE FOREACH
         END IF
         SELECT COUNT(*) INTO li_zycount FROM zy_file
          WHERE zy01='CLASS-A' AND zy02=lc_zz01
         IF li_zycount = 1 THEN
           DISPLAY "Updating..",lc_zz01
           UPDATE zy_file SET zy03=lc_zy03, zy04='0', zy05='0', zy07='0'
            WHERE zy01='CLASS-A' AND zy02=lc_zz01
           LET li_upd = li_upd + 1
         END IF
         IF li_zycount = 0 THEN
           DISPLAY "Inserting..",lc_zz01
           INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy07,zyoriu,zyorig)
           VALUES('CLASS-A',lc_zz01,lc_zy03,'0','0','0', g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
           LET li_ins = li_ins + 1
         END IF
      END IF
   END FOREACH
 
   CLOSE p_mis_chk3_curl
   FREE p_mis_chk3_curl

   DISPLAY " Succeesful! Total Update:",li_upd," Rows Insert:",li_ins," Rows"
 
   RETURN
END FUNCTION
 
FUNCTION p_mis_chk4()  # 重新產生 4ad by zz (because zz011)
 
   DEFINE lc_db          LIKE type_file.chr3
   DEFINE ls_top         STRING
   DEFINE ls_topcust     STRING
   DEFINE lc_gap01       LIKE gap_file.gap01
   DEFINE lc_zz01        LIKE zz_file.zz01
   DEFINE lc_zz011       LIKE zz_file.zz011
   DEFINE lc_zz08        LIKE zz_file.zz08
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
   DEFINE lc_channel     base.Channel
   DEFINE lr_log         STRING
   DEFINE lc_log         STRING
   DEFINE ls_text        STRING              #FUN-A60023
 
   LET lc_db = cl_db_get_database_type()  #FUN-830022
   LET ls_top = os.Path.join(FGL_GETENV("TOP"),"config")
   LET ls_topcust = os.Path.join(FGL_GETENV("CUST"),"config")
 
   DECLARE p_mis_chk4_curl CURSOR FOR
      SELECT UNIQUE gap01 FROM gap_file WHERE 1=1 ORDER BY gap01
   FOREACH p_mis_chk4_curl INTO lc_gap01
 
      IF SQLCA.SQLCODE THEN
         ERROR " Generating 4ad Error:",SQLCA.sqlcode
         DISPLAY lc_gap01 CLIPPED,": Generating 4ad Error:",SQLCA.sqlcode
         LET lc_log="echo ", lc_gap01 CLIPPED,": Generating 4ad Error:",SQLCA.sqlcode," >>$TEMPDIR/$(date +p_mis_log20%y%m%d.log)"
         RUN lc_log 
      ELSE
         CASE lc_db
            WHEN "ORA"
               LET lc_zz08="%",lc_gap01 CLIPPED,"%"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "IFX"
               LET lc_zz08="*",lc_gap01 CLIPPED,"*"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 MATCHES '",lc_zz08 CLIPPED,"' "
            WHEN "MSV"   #FUN-830022
               LET lc_zz08="%",lc_gap01 CLIPPED,"%"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "ASE"   #FUN-AB0041
               LET lc_zz08="%",lc_gap01 CLIPPED,"%"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
         END CASE
 
         DECLARE p_mis_chk41_curl CURSOR FROM ls_sql
         FOREACH p_mis_chk41_curl INTO lc_zz01,lc_zz011
 
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
               LET ls_filename = os.Path.join(os.Path.join(ls_filename,lc_zz011 CLIPPED),lc_gap01 CLIPPED||".4ad")
               display "Info 4ad name = ",ls_filename 
 
#              LET ls_str = "cat /dev/null 2>>$TEMPDIR/$(date +p_mis_log20%y%m%d.log) > ", ls_filename CLIPPED  #TQC-630006
#              RUN ls_str
               CALL cl_null_cat_to_file(ls_filename CLIPPED)   #FUN-9B0113

               LET li_openhead = FALSE
               LET ls_sql = " SELECT gap02,gbd04,gbd05 FROM gap_file, gbd_file ",
                             " WHERE gap_file.gap01='",lc_gap01 CLIPPED,"' ",
                               " AND gbd_file.gbd01=gap_file.gap02 ",
                               " AND gbd_file.gbd02='standard' ",
                               " AND gbd_file.gbd03='",lc_gay01 CLIPPED,"' ",
                               " AND gbd_file.gbd06 != 'Y' ",
                               " AND gbd_file.gbd07='N' "   #FUN-530022
 
               PREPARE p_mis_chk43_pre FROM ls_sql           #預備一下
               DECLARE p_mis_chk43_curl CURSOR FOR p_mis_chk43_pre
 
               FOREACH p_mis_chk43_curl INTO la_gbd.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                     
                     CONTINUE FOREACH
                  ELSE
                     # 2004/06/14 再看一下有沒有自設的, 有的話就倒回去
                     LET lc_gbd04 = ""
                     LET lc_gbd05 = ""
                     SELECT gbd04,gbd05 INTO lc_gbd04,lc_gbd05 FROM gbd_file
                      WHERE gbd_file.gbd01=la_gbd.gbd01
                        AND gbd_file.gbd02=lc_gap01
                        AND gbd_file.gbd03=lc_gay01
                        AND gbd_file.gbd07='N'
 
                     IF NOT cl_null(lc_gbd04) THEN
                        LET la_gbd.gbd04=lc_gbd04 CLIPPED
                     END IF
                     IF NOT cl_null(lc_gbd05) THEN
                        LET la_gbd.gbd05=lc_gbd05 CLIPPED
                     END IF
 
                     #FUN-A60023
                     LET ls_text = la_gbd.gbd04      
                     LET ls_text = cl_replace_str(ls_text, "<" , "&lt;")
                     LET ls_text = cl_replace_str(ls_text, ">" , "&gt;") 
                     
                     # 2004/06/14 看有沒有 comments 有就倒
                     IF cl_null(la_gbd.gbd05) THEN
                        LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" />"
                     ELSE
                        LET ls_str = "   <ActionDefault name=\"",la_gbd.gbd01 CLIPPED,"\" text=\"",ls_text CLIPPED,"\" comment=\"",la_gbd.gbd05 CLIPPED,"\" />"
                     END IF
 
                     IF li_openhead = FALSE THEN
                        # 2004/04/17 輸出檔頭
                        LET lc_channel = base.Channel.create()
                        CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
                        CALL lc_channel.setDelimiter("")
                        CALL lc_channel.write("<?xml version='1.0'?>")
                        CALL lc_channel.write("<ActionDefaultList>")
                        LET li_openhead = TRUE
                     END IF
 
                     CALL lc_channel.write(ls_str)
                  END IF
               END FOREACH
 
               IF li_openhead = TRUE THEN
                  CALL lc_channel.write("</ActionDefaultList>")
                  CALL lc_channel.close()
               END IF
            END FOREACH
         END FOREACH
      END IF
   END FOREACH
   RETURN
END FUNCTION
 
FUNCTION p_mis_chk5()  # 重新產生 4tm by gap
 
   DEFINE lc_db          LIKE type_file.chr3
   DEFINE ls_top         STRING
   DEFINE ls_topcust     STRING
   DEFINE lc_gap01       LIKE gap_file.gap01
   DEFINE lc_gap02       LIKE gap_file.gap02
   DEFINE lc_zz01        LIKE zz_file.zz01
   DEFINE lc_zz011       LIKE zz_file.zz011
   DEFINE lc_zz08        LIKE zz_file.zz08
   DEFINE ls_filename    STRING
   DEFINE ls_sql         STRING
   DEFINE ls_str         STRING
   DEFINE li_openhead    LIKE type_file.num5
   DEFINE lc_channel     base.Channel
   DEFINE lr_log         STRING
   DEFINE lc_log         STRING
 
   LET lc_db=cl_db_get_database_type()    #FUN-830022
   LET ls_top = os.Path.join(FGL_GETENV("TOP"),"config")
   LET ls_topcust = os.Path.join(FGL_GETENV("CUST"),"config")
 
   DECLARE p_mis_chk5_curl CURSOR FOR
      SELECT UNIQUE gap01 FROM gap_file WHERE 1=1 ORDER BY gap01
   FOREACH p_mis_chk5_curl INTO lc_gap01
 
      IF SQLCA.SQLCODE THEN
         ERROR "Generating 4tm Error:",SQLCA.sqlcode
         DISPLAY lc_gap01 CLIPPED,": Generating 4tm Error:",SQLCA.sqlcode
         LET lc_log="echo ",lc_gap01 CLIPPED,": Generating 4tm Error:",SQLCA.sqlcode," >>$TEMPDIR/$(date +p_mis_log20%y%m%d.log)"
         RUN lc_log  
      ELSE
         CASE lc_db
            WHEN "ORA"
               LET lc_zz08="%",lc_gap01 CLIPPED,"%"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "IFX"
               LET lc_zz08="*",lc_gap01 CLIPPED,"*"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 MATCHES '",lc_zz08 CLIPPED,"' "
            WHEN "MSV"    #FUN-830022
               LET lc_zz08="%",lc_gap01 CLIPPED,"%"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
            WHEN "ASE"    #FUN-AB0041
               LET lc_zz08="%",lc_gap01 CLIPPED,"%"
               LET ls_sql="SELECT zz01,zz011 FROM zz_file WHERE zz08 LIKE '",lc_zz08 CLIPPED,"' "
         END CASE
 
         DECLARE p_mis_chk51_curl CURSOR FROM ls_sql
         FOREACH p_mis_chk51_curl INTO lc_zz01,lc_zz011
 
            LET lc_zz011 = DOWNSHIFT(lc_zz011)
            IF lc_zz011[1,1] = "c" THEN
               LET ls_filename = ls_topcust.trim()
            ELSE
               LET ls_filename = ls_top.trim()
            END IF
            LET ls_filename = os.Path.join(os.Path.join(ls_filename,"4tm"),lc_zz011 CLIPPED)
            LET ls_filename = os.Path.join(ls_filename,lc_gap01 CLIPPED||".4tm")
            display "Info 4tm name = ",ls_filename
 
#           LET ls_str = "cat /dev/null 2>>$TEMPDIR/$(date +p_mis_log20%y%m%d.log) > ", ls_filename CLIPPED   #TQC-630006
#           RUN ls_str
            CALL cl_null_cat_to_file(ls_filename CLIPPED)          #FUN-9B0113
 
            LET li_openhead = FALSE
 
            LET ls_sql = " SELECT gap02 FROM gap_file ",
                          " WHERE gap01='",lc_gap01 CLIPPED,"' ",
                            " AND gap05= 'Y' "
 
            PREPARE p_mis_chk52_pre FROM ls_sql
            DECLARE p_mis_chk52_curl CURSOR FOR p_mis_chk52_pre
            FOREACH p_mis_chk52_curl INTO lc_gap02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                  CONTINUE FOREACH
               ELSE
                  LET ls_str = "    <TopMenuCommand name=\"",lc_gap02 CLIPPED,"\"/>"
 
                  IF li_openhead = FALSE THEN
                     # 2004/04/17 輸出檔頭
                     LET lc_channel = base.Channel.create()
                     CALL lc_channel.openFile( ls_filename CLIPPED, "a" )
                     CALL lc_channel.setDelimiter("")
 
                     CALL lc_channel.write("<TopMenu>")
                     CALL lc_channel.write("  <TopMenuGroup text=\"Extra\">")
                     LET li_openhead = TRUE
                  END IF
                  CALL lc_channel.write(ls_str)
               END IF
            END FOREACH
 
            IF li_openhead = TRUE THEN
               CALL lc_channel.write("  </TopMenuGroup>")
               CALL lc_channel.write("</TopMenu>")
            END IF
 
         END FOREACH
      END IF
   END FOREACH
 
   RETURN
END FUNCTION
 
FUNCTION p_mis_chk6()  # 重新產生 help    #TQC-B60011 全部function重新改寫
 
   DEFINE lc_zz01  LIKE zz_file.zz01
   DEFINE lc_gay01 LIKE gay_file.gay01
   DEFINE l_cmd    STRING
   DEFINE la_lang  DYNAMIC ARRAY OF RECORD
             gay01 LIKE gay_file.gay01
                   END RECORD
   DEFINE li_cnt   LIKE type_file.num5
 
   DECLARE p_mis_chk61_curl CURSOR FOR SELECT gay01 FROM gay_file ORDER BY gay01
   LET li_cnt = 1
   CALL la_lang.clear()
   FOREACH p_mis_chk61_curl INTO la_lang[li_cnt].gay01
      LET li_cnt = li_cnt + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   END FOREACH
   CALL la_lang.deleteElement(li_cnt)

   CLOSE p_mis_chk61_curl
   FREE p_mis_chk61_curl

   DECLARE p_mis_chk6_curl CURSOR FOR SELECT zz01 FROM zz_file ORDER BY zz01
   FOREACH p_mis_chk6_curl INTO lc_zz01
 
      FOR li_cnt = 1 TO la_lang.getLength()
         IF lc_zz01[1]="a" OR lc_zz01[1]="p" OR lc_zz01[1]="g" OR lc_zz01[1]="c" OR lc_zz01[1]="u" THEN
            LET l_cmd = "p_help_htm '" || lc_zz01 CLIPPED || "' '",la_lang[li_cnt].gay01 CLIPPED,"' "
            LET l_cmd = "exe2 ",l_cmd
            DISPLAY l_cmd
            RUN l_cmd
#           CALL cl_cmdrun_wait(l_cmd)
         END IF
      END FOR

   END FOREACH

   CLOSE p_mis_chk6_curl
   FREE p_mis_chk6_curl

   RETURN
 
END FUNCTION
 
 
 
FUNCTION p_mis_chk7()   # 重抓 p_zr 資料   FUN-570096
 
   DEFINE lc_gak01  LIKE gak_file.gak01
   DEFINE l_cmd     STRING
 
   DECLARE p_mis_chk7_curl CURSOR FOR
      SELECT UNIQUE gak01 FROM gak_file WHERE 1=1 ORDER BY gak01
 
   FOREACH p_mis_chk7_curl INTO lc_gak01
      IF lc_gak01[1]="a" OR lc_gak01[1]="p" OR lc_gak01[1]="u" OR
         lc_gak01[1]="g" OR lc_gak01[1]="c" THEN
 
         LET l_cmd = "p_get_zr '" || lc_gak01 CLIPPED || "' "
         DISPLAY l_cmd
         CALL cl_cmdrun_unset_lang_wait(l_cmd)
 
      END IF
   END FOREACH

   CLOSE p_mis_chk7_curl
   FREE p_mis_chk7_curl

   RETURN
END FUNCTION
 
 
FUNCTION p_mis_chk8()   # 重抓 p_findfunc 資料   FUN-7B0028
 
   DEFINE l_cmd     STRING
 
   LET l_cmd = "p_get_lib 'lib' "
   DISPLAY l_cmd
   CALL cl_cmdrun_unset_lang_wait(l_cmd)
 
   LET l_cmd = "p_get_lib 'sub' "
   DISPLAY l_cmd
   CALL cl_cmdrun_unset_lang_wait(l_cmd)
 
   RETURN
END FUNCTION
 
 
FUNCTION p_mis_chk9()   # 重新產生 4sm  #FUN-830022
 
   DEFINE lc_zx05   LIKE zx_file.zx05
 
   DECLARE p_mis_chk9_cs CURSOR FOR SELECT UNIQUE(zx05) FROM zx_file
   FOREACH p_mis_chk9_cs INTO lc_zx05
      IF SQLCA.sqlcode THEN
         CALL cl_err('OPEN p_mis_chk9_cs:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      IF NOT cl_null(lc_zx05) THEN
         CALL cl_create_4sm(lc_zx05, FALSE)
      END IF
   END FOREACH

   CLOSE p_mis_chk9_cs
   FREE p_mis_chk9_cs

   RETURN
 
END FUNCTION
 
