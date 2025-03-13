# Prog. Version..: '5.30.06-13.03.27(00010)'     #
#
# Pattern name...: aglp801.4gl
# Descriptions...: 立沖賬資料拋轉
# Date & Author..: NO.FUN-BB0124 11/12/23 By Lori
# Modify.........: No:FUN-BC0001 11/12/23 By Lori 增加功能鍵[立沖帳拋轉前檢核報表]
# Modify.........: No:TQC-BC0022 12/01/11 By Lori 增加語言別功能
# Modify.........: No.TQC-BC0056 12/01/11 By Lori 異動碼9,異動碼10拋轉時給空值
# Modify.........: No:CHI-C20009 12/03/13 By Lori  立沖帳拋轉時注意原始帳別與新帳別所使用的幣別是否相同,不相同時要取得匯率重新計算後再寫入
# Modify.........: No:FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:TQC-BC0169 12/07/24 By Lori  對科目增加專案管立和預算管理比對
# Modify.........: No:FUN-C40112 12/09/10 By Lori  傳票拋轉記錄變更為abm_file
# Modify.........: No:MOD-C90116 12/09/18 By Polly 1.已過帳的傳票不可重新拋轉2.取消abg06/abh021給予g_today
# Modify.........: No:MOD-CA0063 12/10/24 By Dido 沖帳檔若有多筆相同立帳金額累計有誤 
# Modify.........: NO.CHI-C90001 12/11/08 BY Belle 1. 由aglp800 執行時直接串到aglp801 一併進行立沖資料拋轉此種狀況請依aglp800的勾選條件判斷是否要進行轉換
#                                                  2. 直接執行aglp801但畫面上少了條件讓使用者勾選, 應加入同aglp800的勾選欄位
# Modify.........: NO.CHI-CB0057 12/11/23 BY Yiting 與abm_file的串接條件錯誤
# Modify.........: NO.MOD-CB0235 12/11/26 By Yiting FUNCTION p801_abh()中在檢查過帳碼時,  仍使用aba16、aba17欄位做判斷 
# Modify.........: No.MOD-CB0121 13/01/22 By apo 還原p_argv2給予tm.n_abg00
# Modify.........: NO.MOD-D20007 13/02/01 By apo abh應與aba19一致 
# Modify.........: No:CHI-CB0015 13/03/06 By apo aglp800執行aglp801時，增加傳遞傳票起迄編號；aglp801增加傳票起迄編號 

DATABASE ds

GLOBALS "../../config/top.global"                   #FUN-BB0124
GLOBALS "../../agl/4gl/aglp801.global"

DEFINE      tm  RECORD
               o_abg00   LIKE abg_file.abg00,
               n_abg00   LIKE abg_file.abg00,
               o_abg01   LIKE abg_file.abg01,
               b_abg06   LIKE abg_file.abg06,
               e_abg06   LIKE abg_file.abg06
              ,b_abg01   LIKE abg_file.abg01,             #CHI-CB0015 add
               e_abg01   LIKE abg_file.abg01              #CHI-CB0015 add
              END RECORD
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5
DEFINE   g_msg           LIKE type_file.chr1000
DEFINE   l_flag          LIKE type_file.chr1
DEFINE   g_change_lang   LIKE type_file.chr1
DEFINE   ls_date         STRING
DEFINE   g_compare       LIKE type_file.chr1     #CHI-C90001
DEFINE   g_more          LIKE type_file.chr1
DEFINE   g_argv1         LIKE abg_file.abg00

#FUNCTION p801_sub(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6)          #CHI-C90001 mark
#FUNCTION p801_sub(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7)  #CHI-CB0015 mark   #CHI-C90001 mod
FUNCTION p801_sub(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5,p_argv6,p_argv7,p_argv8,p_argv9)      #CHI-CB0015

DEFINE p_argv1    LIKE abg_file.abg00
DEFINE p_argv2    LIKE abg_file.abg00
DEFINE p_argv3    LIKE abg_file.abg01
DEFINE p_argv4    LIKE abg_file.abg06
DEFINE p_argv5    LIKE abg_file.abg06
DEFINE p_argv6    LIKE type_file.chr1
DEFINE p_argv7    LIKE abg_file.abg01     #CHI-CB0015 add
DEFINE p_argv8    LIKE abg_file.abg01     #CHI-CB0015 add
#DEFINE p_argv7    LIKE type_file.chr1    #CHI-CB0015 mark   #CHI-C90001 MOD
DEFINE p_argv9    LIKE type_file.chr1     #CHI-CB0015

  LET g_argv1     = p_argv1
  LET tm.o_abg00  = g_argv1
  LET tm.n_abg00  = p_argv2   #MOD-CB0121 remark
  LET tm.o_abg01  = p_argv3
  LET tm.b_abg06  = p_argv4
  LET tm.e_abg06  = p_argv5
  LET g_more      = p_argv6
  LET tm.b_abg01  = p_argv7      #CHI-CB0015 add
  LET tm.e_abg01  = p_argv8      #CHI-CB0015 add
 #LET g_compare   = p_argv7      #CHI-CB0015 mark   #CHI-C90001	
  LET g_compare   = p_argv9      #CHI-CB0015

##for aglp800
  IF NOT cl_null(g_argv1) THEN
     LET g_return = 'Y'
  ELSE
  	 LET g_return = NULL
  END IF
##

  WHILE TRUE
     LET g_change_lang = FALSE

###for aglp800
     IF g_return = 'Y' THEN
        LET g_success = 'Y'
        CALL p801_abg()
        CALL p801_abh()
        IF g_success = 'N' THEN
           LET g_return = 'N'
        END IF
        EXIT WHILE
     END IF
###for aglp800

     IF g_more = 'N' THEN
        CALL p801_i()
        IF cl_sure(16,21) THEN
           CALL  cl_wait()
           LET g_success = 'Y'
           BEGIN WORK
           CALL  p801_abg()
           CALL  p801_abh()
           CALL s_showmsg()
           IF g_success='Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF NOT cl_null(g_argv1) THEN
             CLOSE WINDOW p801_w
             EXIT WHILE
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p801_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
     ELSE
        LET g_success = 'Y'
        BEGIN WORK
        CALL  p801_abg()
        CALL  p801_abh()
        CALL s_showmsg()
        IF g_success = 'Y' THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
  END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END FUNCTION

FUNCTION p801_i()
 DEFINE     p_row,p_col    LIKE type_file.num5,
            l_sw           LIKE type_file.chr1,          #重要欄位是否空白
            l_cmd          LIKE type_file.chr1000,
            lc_cmd         LIKE type_file.chr1000
 DEFINE     li_chk_bookno  LIKE type_file.num5
 DEFINE     l_aaa13        LIKE aaa_file.aaa13
 DEFINE     l_sql          STRING
 DEFINE     l_aaa01        LIKE aaa_file.aaa01
 DEFINE     l_chr          LIKE type_file.chr1
 DEFINE     l_aac16        LIKE aac_file.aac16

  LET p_row = 2 LET p_col = 26

  IF cl_null(l_flag) THEN
     OPEN WINDOW p801_w AT p_row,p_col WITH FORM "agl/42f/aglp801"
        ATTRIBUTE (STYLE = g_win_style)
  END IF

  CALL cl_ui_init()

  IF NOT cl_null(g_argv1) THEN
     DISPLAY tm.o_abg00 TO o_abg00
     DISPLAY tm.n_abg00 TO n_abg00
     DISPLAY tm.o_abg01 TO o_abg01
     DISPLAY tm.b_abg06 TO b_abg06
     DISPLAY tm.e_abg06 TO e_abg06
     DISPLAY tm.b_abg01 TO b_abg01    #CHI-CB0015 add
     DISPLAY tm.e_abg01 TO e_abg01    #CHI-CB0015 add
     DISPLAY g_more     TO more
     DISPLAY g_compare  TO g_compare   #CHI-C90001 add
  ELSE
     INITIALIZE tm.* TO NULL
     LET tm.o_abg00 = g_aaz.aaz64
     LET tm.n_abg00 = g_aaz.aaz64
     LET tm.b_abg06 = g_today
     LET tm.e_abg06 = g_today
  END IF

  WHILE TRUE
     LET g_more = "N"
     LET g_compare = 'N'  #CHI-C90001 add
    #INPUT tm.o_abg00,tm.n_abg00,tm.o_abg01,tm.b_abg06,tm.e_abg06, g_more     #CHI-C90001 mark
    #INPUT tm.o_abg00,tm.n_abg00,tm.o_abg01,tm.b_abg06,tm.e_abg06, g_compare, #CHI-CB0015 mark   #CHI-C90001 mod 
     INPUT tm.o_abg00,tm.n_abg00,tm.o_abg01,tm.b_abg06,tm.e_abg06,tm.b_abg01,tm.e_abg01,g_compare,   #CHI-CB0015
           g_more                                                             #CHI-C90001 mod
       WITHOUT DEFAULTS
     #FROM o_abg00,n_abg00,o_abg01,b_abg06,e_abg06,more             #CHI-C90001 mark
     #FROM o_abg00,n_abg00,o_abg01,b_abg06,e_abg06,g_compare,more   #CHI-CB0015 mark   #CHI-C90001 add g_compare
      FROM o_abg00,n_abg00,o_abg01,b_abg06,e_abg06,b_abg01,e_abg01,g_compare,more      #CHI-CB0015

      BEFORE INPUT
         IF NOT cl_null(g_argv1) THEN
            CALL cl_set_comp_entry("o_abg00,n_abg00,o_abg01,b_abg06,e_abg06",FALSE)
         ELSE
            CALL cl_set_comp_entry("o_abg00,n_abg00,o_abg01,b_abg06,e_abg06",TRUE)
         END IF

      AFTER FIELD o_abg00         #原始帳別
         IF cl_null(tm.o_abg00) THEN
            NEXT FIELD CURRENT
         ELSE
            CALL s_check_bookno(tm.o_abg00,g_user,g_plant)
               RETURNING li_chk_bookno
            IF (NOT li_chk_bookno) THEN
               NEXT FIELD CURRENT
            END IF
            SELECT COUNT(*) INTO g_cnt FROM aaa_file WHERE aaa01=tm.o_abg00
            IF g_cnt =0 THEN
               CALL cl_err('','anm-062',0)
               NEXT FIELD CURRENT
            END IF
         END IF

      AFTER FIELD n_abg00         #拋轉帳別
         IF cl_null(tm.n_abg00) OR tm.n_abg00=tm.o_abg00 THEN
            CALL cl_err('','agl-515',0)
            NEXT FIELD CURRENT
         END IF

          CALL s_check_bookno(tm.n_abg00,g_user,g_plant)
               RETURNING li_chk_bookno
          IF (NOT li_chk_bookno) THEN
              NEXT FIELD CURRENT
          END IF

          LET g_cnt = 0
          LET l_aaa13 = NULL
          SELECT aaa13,COUNT(*) INTO l_aaa13,g_cnt FROM aaa_file
           WHERE aaa01=tm.n_abg00
           GROUP BY aaa13
          IF g_cnt =0 THEN
            CALL cl_err('','anm-062',0)
            NEXT FIELD CURRENT
          ELSE
          	 IF cl_null(l_aaa13) OR l_aaa13 = 'N' THEN
          	    CALL cl_err('','agl-516',0)
          	    NEXT FIELD CURRENT
          	 END IF
          END IF

      AFTER FIELD o_abg01
          IF cl_null(tm.o_abg01) THEN
             NEXT FIELD CURRENT
          END IF
          IF tm.o_abg01 != '*' THEN
             LET l_aac16 = NULL
             SELECT aac16 INTO l_aac16 FROM aac_file
              WHERE aac01 = tm.o_abg01
                AND aacacti='Y'
             IF cl_null(l_aac16) OR l_aac16 = 'N' THEN
                CALL cl_err('','agl-530',0)
                NEXT FIELD CURRENT
             END IF
          END IF

      AFTER FIELD e_abg06
         IF NOT cl_null(tm.e_abg06) THEN
            IF tm.b_abg06 > tm.e_abg06 THEN
              NEXT FIELD CURRENT
            END IF
         END IF

     #------------------------------CHI-CB0015-----------------------(S)
      BEFORE FIELD e_abg01
         IF NOT cl_null(tm.b_abg01) THEN
            LET tm.e_abg01 = tm.b_abg01 DISPLAY BY NAME tm.e_abg01
         END IF

      AFTER FIELD e_abg01
         IF NOT cl_null(tm.e_abg01) THEN
            IF tm.b_abg01 > tm.e_abg01 THEN NEXT FIELD e_abg01 END IF
         END IF
     #------------------------------CHI-CB0015-----------------------(E)


      #TQC-BC0022--Begin--
      ON ACTION locale
        LET g_change_lang = TRUE
        EXIT INPUT
      #TQC-BC0022--End--

      #FUN-BC0001--Begin--
      ON ACTION r816
        #CALL cl_cmdrun("aglr816")  #FUN-C30085
         CALL cl_cmdrun("aglg816")  #FUN-C30085 
      #FUN-BC0001---End---

      ON ACTION CONTROLR
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
         CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()

      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT

      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT

  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()
     CONTINUE WHILE
  END IF

  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p801_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time
     EXIT PROGRAM
  END IF

    IF g_more = 'Y' THEN
       SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'aglp801'
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aglp801','9031',1)
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm.o_abg00 CLIPPED, "'",
                       " '",tm.n_abg00 CLIPPED, "'",
                       " '",tm.o_abg01 CLIPPED, "'",
                       " '",tm.b_abg06 CLIPPED, "'",
                       " '",tm.e_abg06 CLIPPED, "'",
                       " '",tm.b_abg01 CLIPPED, "'",        #CHI-CB0015 add
                       " '",tm.e_abg01 CLIPPED, "'",        #CHI-CB0015 add
                       " '",g_compare CLIPPED,"'",  #CHI-C90001 add
                       " '",g_more CLIPPED, "'"
          CALL cl_cmdat('aglp801',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p801_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time
       EXIT PROGRAM
    END IF
    EXIT WHILE
END WHILE
END FUNCTION

FUNCTION p801_abg()
   DEFINE l_sql     STRING,
          l_sql2    STRING,
          sr        RECORD LIKE abg_file.*,
          l_n       LIKE type_file.num5,
          l_i       LIKE type_file.num10,
          l_chr     LIKE type_file.chr1
   DEFINE l_count        LIKE type_file.num5              #記錄一個科目在目標帳套中存在的個數
   DEFINE l_abg          RECORD LIKE abg_file.*
   DEFINE l_aag15_1,l_aag15_2    LIKE aag_file.aag15
   DEFINE l_aag151_1,l_aag151_2  LIKE aag_file.aag151
   DEFINE l_aag16_1,l_aag16_2    LIKE aag_file.aag16
   DEFINE l_aag161_1,l_aag161_2  LIKE aag_file.aag161
   DEFINE l_aag17_1,l_aag17_2    LIKE aag_file.aag17
   DEFINE l_aag171_1,l_aag171_2  LIKE aag_file.aag171
   DEFINE l_aag18_1,l_aag18_2    LIKE aag_file.aag18
   DEFINE l_aag181_1,l_aag181_2  LIKE aag_file.aag181
   DEFINE l_aag20_1,l_aag20_2    LIKE aag_file.aag20
   DEFINE l_aag222_1,l_aag222_2  LIKE aag_file.aag222

   #TQC-BC0169--Begin--
   DEFINE l_aag21_1,l_aag21_2    LIKE aag_file.aag21
   DEFINE l_aag23_1,l_aag23_2    LIKE aag_file.aag23
   #TQC-BC0169--End--

   DEFINE l_aag31_1,l_aag31_2    LIKE aag_file.aag31
   DEFINE l_aag311_1,l_aag311_2  LIKE aag_file.aag311
   DEFINE l_aag32_1,l_aag32_2    LIKE aag_file.aag32
   DEFINE l_aag321_1,l_aag321_2  LIKE aag_file.aag321
   DEFINE l_aag33_1,l_aag33_2    LIKE aag_file.aag33
   DEFINE l_aag331_1,l_aag331_2  LIKE aag_file.aag331
   DEFINE l_aag34_1,l_aag34_2    LIKE aag_file.aag34
   DEFINE l_aag341_1,l_aag341_2  LIKE aag_file.aag341
  #TQC-BC0056--Begin--
  #DEFINE l_aag35_1,l_aag35_2    LIKE aag_file.aag35
  #DEFINE l_aag351_1,l_aag351_2  LIKE aag_file.aag351
  #DEFINE l_aag36_1,l_aag36_2    LIKE aag_file.aag36
  #DEFINE l_aag361_1,l_aag361_2  LIKE aag_file.aag361
   DEFINE l_aag05_1,l_aag05_2    LIKE aag_file.aag05
  #TQC-BC0056---End---
   DEFINE l_aaa13                LIKE aaa_file.aaa13 
   #CHI-C20009--Begin--
   DEFINE l_aaa03_1 LIKE aaa_file.aaa03,             #來源帳幣別
          l_aaa03_2 LIKE aaa_file.aaa03,             #拋轉帳幣別
          l_azi04   LIKE azi_file.azi04,             #取位
          l_abb25   LIKE abb_file.abb25              #匯率
   #CHI-C20009--End--
   DEFINE l_post  LIKE aba_file.abapost            #MOD-C90116 add
   DEFINE l_abg01 LIKE abg_file.abg01              #MOD-C90116 add
   DEFINE l_tag05   LIKE tag_file.tag05   #CHI-C90001 add
   
   IF tm.o_abg01 = '*' THEN
     LET l_sql = "SELECT abg_file.* FROM abg_file,aac_file",
                 " WHERE abg00='",tm.o_abg00,"'",               #帳別
                 "   AND abg01[1,",g_doc_len,"]= aac01",
                 "   AND aac16 = 'Y'"
   ELSE
     LET l_sql = "SELECT abg_file.* FROM abg_file,aac_file",
                 " WHERE abg00='",tm.o_abg00,"'",                   #帳別
                 "   AND abg01[1,",g_doc_len,"]='",tm.o_abg01,"'",   #單別
                 "   AND abg01[1,",g_doc_len,"]= aac01",
                 "   AND aac16 = 'Y'"
   END IF

     #傳票日期
     IF tm.b_abg06 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg06  >= '",tm.b_abg06,"'"
     END IF
     IF tm.e_abg06 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg06  <= '",tm.e_abg06,"'"
     END IF
  
    #---------------------------------CHI-CB0015---------------------(S)
    #傳票編號
     IF tm.b_abg01 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg01 >= '",tm.b_abg01,"'"
     END IF 
     IF tm.e_abg01 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg01 <= '",tm.e_abg01,"'"
     END IF 
    #---------------------------------CHI-CB0015---------------------(E)

     LET l_sql = l_sql CLIPPED," ORDER BY abg01"

     PREPARE p801_p1 FROM l_sql
     DECLARE p801_c1 CURSOR WITH HOLD FOR p801_p1

   IF cl_null(g_return) THEN       #for aglp800
     CALL s_showmsg_init()
   END IF                          #for aglp800

     LET l_abg01 = ' '                                #MOD-C90116 add
     FOREACH p801_c1 INTO sr.*
        IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success='Y'
        END IF
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('abg00',tm.o_abg00,'foreach:',SQLCA.sqlcode,1)
           LET g_success ='N'
           EXIT FOREACH
	      END IF

#######2.carry ?
        LET l_count = 0
       #FUN-C40112-Mark Begin---
       #SELECT COUNT(*) INTO l_count FROM aba_file
       # WHERE aba16 = tm.n_abg00
       #   AND aba17 = sr.abg01
       #FUN-C40112-Mark End-----

       #FUN-C40112 Add Begin---
        SELECT COUNT(*) INTO l_count FROM aba_file LEFT OUTER JOIN abm_file
            #ON aba00 = abm02 AND aba01 = abm03 AND aba01 = abm06
            ON aba00 = abm02 AND aba01 = abm03  #CHI-CB0057 mod
         WHERE abm05 = tm.n_abg00
           AND abm06 = sr.abg01
       #FUN-C40112 Add End-----
        IF l_count = 0 THEN
           LET g_showmsg = sr.abg00,"/",sr.abg01
           CALL s_errmsg('abg00,abg01',g_showmsg,'','agl-518',1)
           LET g_success = 'N'
        END IF

      #-----------------------MOD-C90116-----------------------(s)
       LET l_post = ' '
       #--MOD-CB0235 mark--start--
       #SELECT abapost INTO l_post FROM aba_file
       # WHERE aba16 = tm.n_abg00
       #   AND aba17 = sr.abg01
       #--MOD-CB0235 mark--end---

       #--MOD-CB0235 start--
       SELECT abapost INTO l_post FROM aba_file LEFT OUTER JOIN abm_file
           ON aba00 = abm05 AND aba01 = abm06  
        WHERE abm05 = tm.n_abg00
          AND abm06 = sr.abg01
       #--MOD-CB0235 end----
       IF l_post='Y' THEN
          LET g_totsuccess = 'N'
          IF cl_null(l_abg01) OR sr.abg01 <> l_abg01 THEN
             LET g_showmsg = sr.abg00,"/",sr.abg01
             CALL s_errmsg('abg00,abg01',g_showmsg,sr.abg01,'agl-208',1)
             LET l_abg01 = sr.abg01
             CONTINUE FOREACH
          ELSE
             LET l_abg01 = sr.abg01
             CONTINUE FOREACH
          END IF
       END IF
      #-----------------------MOD-C90116-----------------------(E)
      #--CHI-C90001 start---
      LET l_count =0 
      IF g_compare='Y' THEN
          LET l_tag05=''    
          SELECT tag05 INTO l_tag05
            FROM tag_file 
           WHERE tag01 = YEAR(sr.abg06) 
             AND tag02 = tm.o_abg00 
             AND tag03 = sr.abg03
             AND tagacti = 'Y' 
             AND tag06 = '1'   
          SELECT COUNT(*) INTO l_count FROM aag_file
           WHERE aag00= tm.n_abg00
             AND aag01= l_tag05
             AND aagacti = 'Y'   
          IF l_count =0 THEN
             LET g_showmsg = tm.n_abg00 CLIPPED,"/",sr.abg01 CLIPPED,"/",sr.abg03 CLIPPED      
             CALL s_errmsg('abg00,abg01,abg03',g_showmsg,'','agl-229',1)  
             LET g_success='N'                    
             LET l_tag05 = sr.abg03
          END IF
      ELSE
          LET l_tag05 = sr.abg03
      END IF
      #--CHI-C90001  end--
#####kemu abg_file
       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
              aag20,aag222,
              aag21,aag23,                                 #TQC-BC0169
              aag31,aag311,aag32,aag321,aag33,aag331,
             #aag34,aag341,aag35,aag351,aag36,aag361       #TQC-BC0056
              aag34,aag341,aag05                           #TQC-BC0056
         INTO l_aag15_1,l_aag151_1,l_aag16_1,l_aag161_1,l_aag17_1,
              l_aag171_1,l_aag18_1,l_aag181_1,l_aag20_1,l_aag222_1,
              l_aag21_1,l_aag23_1,                         #TQC-BC0169
              l_aag31_1,l_aag311_1,l_aag32_1,l_aag321_1,l_aag33_1,
              l_aag331_1,l_aag34_1,l_aag341_1,l_aag05_1  #l_aag35_1,l_aag351_1,  #TQC-BC0056
             #l_aag36_1,l_aag361_1                       #TQC-BC0056
         FROM aag_file
        WHERE aag00   = tm.o_abg00
          AND aag01   = sr.abg03
          AND aagacti = 'Y'

       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
              aag20,aag222,
              aag21,aag23,                                #TQC-BC0169
              aag31,aag331,aag32,aag321,aag33,aag331,
             #aag34,aag341,aag35,aag351,aag36,aag361      #TQC-BC0056
              aag34,aag341,aag05                          #TQC-BC0056
         INTO l_aag15_2,l_aag151_2,l_aag16_2,l_aag161_2,l_aag17_2,
              l_aag171_2,l_aag18_2,l_aag181_2,l_aag20_2,l_aag222_2,
              l_aag21_2,l_aag23_2,                        #TQC-BC0169
              l_aag31_2,l_aag311_2,l_aag32_2,l_aag321_2,l_aag33_2,
              l_aag331_2,l_aag34_2,l_aag341_2,l_aag05_2   #l_aag35_2,l_aag351_2,  #TQC-BC0056
             #l_aag36_2,l_aag361_2                        #TQC-BC0056
         FROM aag_file
        WHERE aag00   = tm.n_abg00
         #AND aag01   = sr.abg03     #CHI-C90001 MARK
          AND aag01  = l_tag05       #CHI-C90001 mod
          AND aagacti = 'Y'
#--CHI-C90001 mark--移到前段做--
#       LET l_count = 0
#       SELECT COUNT(*) INTO l_count FROM aag_file
#        WHERE aag00   = tm.n_abg00
#          AND aag01  = sr.abg03   #CHI-C90001 mark
#          AND aagacti = 'Y'
#        IF l_count = 0 THEN
#          #LET g_showmsg = tm.n_abg00,"/",sr.abg03  #TQC-C60199
#           LET g_showmsg = tm.n_abg00 CLIPPED,"/",sr.abg03 CLIPPED   #TQC-C60199
#           CALL s_errmsg('abg00,abg03',g_showmsg,'','agl-229',1)
#           LET g_success = 'N'
#        END IF
#--CHI-C90001 mark----

        IF cl_null(l_aag15_1 ) THEN LET l_aag15_1 =' '   END IF
        IF cl_null(l_aag151_1) THEN LET l_aag151_1 =' '  END IF
        IF cl_null(l_aag16_1 ) THEN LET l_aag16_1  =' '  END IF
        IF cl_null(l_aag161_1) THEN LET l_aag161_1 =' '  END IF
        IF cl_null(l_aag17_1 ) THEN LET l_aag17_1  =' '  END IF
        IF cl_null(l_aag171_1) THEN LET l_aag171_1 =' '  END IF
        IF cl_null(l_aag18_1 ) THEN LET l_aag18_1  =' '  END IF
        IF cl_null(l_aag181_1) THEN LET l_aag181_1 =' '  END IF
        IF cl_null(l_aag20_1 ) THEN LET l_aag20_1  =' '  END IF
        IF cl_null(l_aag222_1) THEN LET l_aag222_1 =' '  END IF

        #TQC-BC0169--Begin--
        IF cl_null(l_aag21_1 ) THEN LET l_aag21_1  =' '  END IF
        IF cl_null(l_aag23_1 ) THEN LET l_aag23_1  =' '  END IF
        #TQC-BC0169--End--

        IF cl_null(l_aag31_1 ) THEN LET l_aag31_1  =' '  END IF
        IF cl_null(l_aag311_1) THEN LET l_aag311_1 =' '  END IF
        IF cl_null(l_aag32_1 ) THEN LET l_aag32_1  =' '  END IF
        IF cl_null(l_aag321_1) THEN LET l_aag321_1 =' '  END IF
        IF cl_null(l_aag33_1 ) THEN LET l_aag33_1  =' '  END IF
        IF cl_null(l_aag331_1) THEN LET l_aag331_1 =' '  END IF
        IF cl_null(l_aag34_1 ) THEN LET l_aag34_1  =' '  END IF
        IF cl_null(l_aag341_1) THEN LET l_aag341_1 =' '  END IF
       #TQC-BC0056--Begin--
       #IF cl_null(l_aag35_1 ) THEN LET l_aag35_1  =' '  END IF
       #IF cl_null(l_aag351_1) THEN LET l_aag351_1 =' '  END IF
       #IF cl_null(l_aag36_1 ) THEN LET l_aag36_1  =' '  END IF
       #IF cl_null(l_aag361_1) THEN LET l_aag361_1 =' '  END IF
        IF cl_null(l_aag05_1 ) THEN LET l_aag05_1  =' '  END IF
       #TQC-BC0056---End---

        IF cl_null(l_aag15_2) THEN LET l_aag15_2 =' '   END IF
        IF cl_null(l_aag151_2) THEN LET l_aag151_2 =' '  END IF
        IF cl_null(l_aag16_2) THEN LET l_aag16_2  =' '  END IF
        IF cl_null(l_aag161_2) THEN LET l_aag161_2 =' '  END IF
        IF cl_null(l_aag17_2) THEN LET l_aag17_2  =' '  END IF
        IF cl_null(l_aag171_2) THEN LET l_aag171_2 =' '  END IF
        IF cl_null(l_aag18_2) THEN LET l_aag18_2  =' '  END IF
        IF cl_null(l_aag181_2) THEN LET l_aag181_2 =' '  END IF
        IF cl_null(l_aag20_2) THEN LET l_aag20_2  =' '  END IF
        IF cl_null(l_aag222_2) THEN LET l_aag222_2 =' '  END IF

        #TQC-BC0169--Begin--
        IF cl_null(l_aag21_2 ) THEN LET l_aag21_2  =' '  END IF
        IF cl_null(l_aag23_2 ) THEN LET l_aag23_2  =' '  END IF
        #TQC-BC0169--End--

        IF cl_null(l_aag31_2) THEN LET l_aag31_2  =' '  END IF
        IF cl_null(l_aag311_2) THEN LET l_aag311_2 =' '  END IF
        IF cl_null(l_aag32_2) THEN LET l_aag32_2  =' '  END IF
        IF cl_null(l_aag321_2) THEN LET l_aag321_2 =' '  END IF
        IF cl_null(l_aag33_2) THEN LET l_aag33_2  =' '  END IF
        IF cl_null(l_aag331_2) THEN LET l_aag331_2 =' '  END IF
        IF cl_null(l_aag34_2) THEN LET l_aag34_2  =' '  END IF
        IF cl_null(l_aag341_2) THEN LET l_aag341_2 =' '  END IF
       #TQC-BC0056--Begin--
       #IF cl_null(l_aag35_2) THEN LET l_aag35_2  =' '  END IF
       #IF cl_null(l_aag351_2) THEN LET l_aag351_2 =' '  END IF
       #IF cl_null(l_aag36_2) THEN LET l_aag36_2  =' '  END IF
       #IF cl_null(l_aag361_2) THEN LET l_aag361_2 =' '  END IF
        IF cl_null(l_aag05_2) THEN LET l_aag05_2  =' '  END IF
       #TQC-BC0056---End---

        IF l_aag15_1  = l_aag15_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag15"
           CALL s_errmsg('abg00,abg03,aag15',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag151_1 =l_aag151_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag151"
           CALL s_errmsg('abg00,abg03,aag151',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag16_1  =l_aag16_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag16"
           CALL s_errmsg('abg00,abg03,aag16',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag161_1 =l_aag161_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag161"
           CALL s_errmsg('abg00,abg03,aag161',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag17_1  =l_aag17_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag17"
           CALL s_errmsg('abg00,abg03,aag17',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag171_1 =l_aag171_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag171"
           CALL s_errmsg('abg00,abg03,aag171',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag18_1  =l_aag18_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag11"
           CALL s_errmsg('abg00,abg03,aag18',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag181_1 =l_aag181_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag181"
           CALL s_errmsg('abg00,abg03,aag181',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag20_1  =l_aag20_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag20"
           CALL s_errmsg('abg00,abg03,aag20',g_showmsg,'','agl-520',1)
           LET g_success = 'N'
        END IF
        IF l_aag222_1 =l_aag222_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag222"
           CALL s_errmsg('abg00,abg03,aag222',g_showmsg,'','agl-521',1)
           LET g_success = 'N'
        END IF

        #TQC-BC0169--Begin--
        IF l_aag21_1  =l_aag21_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag21"
           CALL s_errmsg('abg00,abg03,aag21',g_showmsg,'','agl1024',1)
           LET g_success = 'N'
        END IF
        IF l_aag23_1 =l_aag23_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag23"
           CALL s_errmsg('abg00,abg03,aag23',g_showmsg,'','agl1025',1)
           LET g_success = 'N'
        END IF
        #TQC-BC0169--End--

        IF l_aag31_1  =l_aag31_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag31"
           CALL s_errmsg('abg00,abg03,aag31',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag311_1 =l_aag311_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag311"
           CALL s_errmsg('abg00,abg03,aag311',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag32_1  =l_aag32_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag32"
           CALL s_errmsg('abg00,abg03,aag32',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag321_1 =l_aag321_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag321"
           CALL s_errmsg('abg00,abg03,aag321',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag33_1  =l_aag33_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag33"
           CALL s_errmsg('abg00,abg03,aag33',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag331_1 =l_aag331_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag331"
           CALL s_errmsg('abg00,abg03,aag331',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag34_1  =l_aag34_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag34"
           CALL s_errmsg('abg00,abg03,aag34',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag341_1 =l_aag341_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag341"
           CALL s_errmsg('abg00,abg03,aag341',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
       #TQC-BC0056--Begin--
       #IF l_aag35_1  =l_aag35_2  THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag35"
       #   CALL s_errmsg('abg00,abg03,aag35',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #IF l_aag351_1 =l_aag351_2 THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag351"
       #   CALL s_errmsg('abg00,abg03,aag351',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #IF l_aag36_1  =l_aag36_2  THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag36"
       #   CALL s_errmsg('abg00,abg03,aag36',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #IF l_aag361_1 =l_aag361_2 THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag361"
       #   CALL s_errmsg('abg00,abg03,aag361',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #TQC-BC0056---End---
       #TQC-BC0056--Begin--
       #判斷部門管理
        IF l_aag05_1 <> l_aag05_2  THEN
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag051"
          #CALL s_errmsg('abg00,abg03,aag051',g_showmsg,'','agl1020',1)  #CHI-C90001 mark
           CALL s_errmsg('abg00,abg03,aag05',g_showmsg,'','agl1020',1)   #CHI-C90001 mod
           LET g_success = 'N'
        END IF
       #TQC-BC0056---End---
  ######delete
           DELETE FROM abg_file WHERE abg00 = tm.n_abg00
                                  AND abg01 = sr.abg01
                                  AND abg02 = sr.abg02
        LET l_abg.* = sr.*
        LET l_abg.abg00=tm.n_abg00

        LET l_aaa13 = NULL
        SELECT aaa13 INTO l_aaa13 FROM aaa_file
         WHERE aaa01=tm.n_abg00
        IF cl_null(l_aaa13) OR l_aaa13 = 'N' THEN
           LET g_showmsg = tm.n_abg00
           CALL s_errmsg('abg00',g_showmsg,'','agl-516',1)
           LET g_success = 'N'        
           CONTINUE FOREACH 
        END IF
                  
       #LET l_abg.abg06 = g_today       #MOD-C90116 mark
        IF cl_null(l_abg.abg071) THEN
           LET l_abg.abg071 = 0
        END IF
        LET l_abg.abg072 = 0
        LET l_abg.abg073 = 0

         LET l_abg.abg11 = sr.abg11
         LET l_abg.abg12 = sr.abg12
         LET l_abg.abg13 = sr.abg13
         LET l_abg.abg14 = sr.abg14
         LET l_abg.abg31 = sr.abg31
         LET l_abg.abg32 = sr.abg32
         LET l_abg.abg33 = sr.abg33
         LET l_abg.abg34 = sr.abg34
        #TQC-BC0056--Begin Mark--
        #LET l_abg.abg35 = sr.abg35
        #LET l_abg.abg36 = sr.abg36 
        #TQC-BC0056---End Mark---

         IF cl_null(l_abg.abg11) THEN LET l_abg.abg11 = "" END IF
         IF cl_null(l_abg.abg12) THEN LET l_abg.abg12 = "" END IF
         IF cl_null(l_abg.abg13) THEN LET l_abg.abg13 = "" END IF
         IF cl_null(l_abg.abg14) THEN LET l_abg.abg14 = "" END IF
         IF cl_null(l_abg.abg31) THEN LET l_abg.abg31 = "" END IF
         IF cl_null(l_abg.abg32) THEN LET l_abg.abg32 = "" END IF
         IF cl_null(l_abg.abg33) THEN LET l_abg.abg33 = "" END IF
         IF cl_null(l_abg.abg34) THEN LET l_abg.abg34 = "" END IF
        #TQC-BC0056--Begin--
        #IF cl_null(l_abg.abg35) THEN LET l_abg.abg35 = "" END IF
        #IF cl_null(l_abg.abg36) THEN LET l_abg.abg36 = "" END IF
         LET l_abg.abg35 = ""
         LET l_abg.abg36 = ""
        #TQC-BC0056---End---
        LET l_abg.abg03 =  l_tag05   #CHI-C90001

       #CHI-C20009--Begin--
       #來源帳別幣別與目地帳別幣別相同時,傳票金額不需重算
       SELECT aaa03 INTO l_aaa03_1 FROM aaa_file WHERE aaa01 = tm.o_abg00
       SELECT aaa03 INTO l_aaa03_2 FROM aaa_file WHERE aaa01 = tm.n_abg00
       SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = l_aaa03_2
       IF l_aaa03_1 <> l_aaa03_2 THEN
         #匯率抓取應依參數設定aza19(1.月平均 2.每日),
         #再決定要抓取每月或每日匯率                #M:銀行中價匯率
          CALL s_curr3(l_aaa03_2,l_abg.abg06,'M') RETURNING l_abb25
          LET l_abg.abg071 = l_abb25 * l_abg.abg071
          LET l_abg.abg071 = cl_digcut(l_abg.abg071,l_azi04)
       END IF
       #CHI-C20009--End--

        INSERT INTO abg_file VALUES(l_abg.*)
        IF STATUS THEN
           CALL s_errmsg('insert abg_file','','',STATUS,1)
           LET g_success = 'N'
        END IF
    END FOREACH

    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
END FUNCTION

FUNCTION p801_abh()
   DEFINE l_sql     STRING,
          l_sql2    STRING,
          sr        RECORD LIKE abg_file.*,
          sr1       RECORD LIKE abh_file.*,
          l_n       LIKE type_file.num5,
          l_i       LIKE type_file.num10,
          l_chr     LIKE type_file.chr1
   DEFINE l_count        LIKE type_file.num5              #記錄一個科目在目標帳套中存在的個數
   DEFINE l_abg          RECORD LIKE abg_file.*
   DEFINE l_abh          RECORD LIKE abh_file.*
   DEFINE l_aag15_1,l_aag15_2    LIKE aag_file.aag15
   DEFINE l_aag151_1,l_aag151_2  LIKE aag_file.aag151
   DEFINE l_aag16_1,l_aag16_2    LIKE aag_file.aag16
   DEFINE l_aag161_1,l_aag161_2  LIKE aag_file.aag161
   DEFINE l_aag17_1,l_aag17_2    LIKE aag_file.aag17
   DEFINE l_aag171_1,l_aag171_2  LIKE aag_file.aag171
   DEFINE l_aag18_1,l_aag18_2    LIKE aag_file.aag18
   DEFINE l_aag181_1,l_aag181_2  LIKE aag_file.aag181
   DEFINE l_aag20_1,l_aag20_2    LIKE aag_file.aag20
   DEFINE l_aag222_1,l_aag222_2  LIKE aag_file.aag222

   #TQC-BC0169--Begin--
   DEFINE l_aag21_1,l_aag21_2    LIKE aag_file.aag21
   DEFINE l_aag23_1,l_aag23_2    LIKE aag_file.aag23
   #TQC-BC0169--End--

   DEFINE l_aag31_1,l_aag31_2    LIKE aag_file.aag31
   DEFINE l_aag311_1,l_aag311_2  LIKE aag_file.aag311
   DEFINE l_aag32_1,l_aag32_2    LIKE aag_file.aag32
   DEFINE l_aag321_1,l_aag321_2  LIKE aag_file.aag321
   DEFINE l_aag33_1,l_aag33_2    LIKE aag_file.aag33
   DEFINE l_aag331_1,l_aag331_2  LIKE aag_file.aag331
   DEFINE l_aag34_1,l_aag34_2    LIKE aag_file.aag34
   DEFINE l_aag341_1,l_aag341_2  LIKE aag_file.aag341
  #TQC-BC0056--Begin--
   DEFINE l_aag05_1,l_aag05_2    LIKE aag_file.aag05
  #DEFINE l_aag35_1,l_aag35_2    LIKE aag_file.aag35
  #DEFINE l_aag351_1,l_aag351_2  LIKE aag_file.aag351
  #DEFINE l_aag36_1,l_aag36_2    LIKE aag_file.aag36
  #DEFINE l_aag361_1,l_aag361_2  LIKE aag_file.aag361
  #TQC-BC0056---End---
   DEFINE l_aaa13                LIKE aaa_file.aaa13 
   #CHI-C20009--Begin--
   DEFINE l_aaa03_1 LIKE aaa_file.aaa03,             #來源帳幣別
          l_aaa03_2 LIKE aaa_file.aaa03,             #拋轉帳幣別
          l_azi04   LIKE azi_file.azi04,             #取位
          l_abb25   LIKE abb_file.abb25              #匯率
   #CHI-C20009--End--
   DEFINE l_tag05   LIKE tag_file.tag05   #CHI-C90001 add
   DEFINE l_post  LIKE aba_file.abapost            #MOD-C90116 add
   DEFINE l_abh01 LIKE abh_file.abh01              #MOD-C90116 add

   IF tm.o_abg01 = '*' THEN
     LET l_sql = "SELECT abg_file.*,abh_file.* FROM abg_file,abh_file,aac_file",
                 " WHERE abg00 = abh00 ",
                 "   AND abg01 = abh07",
                 "   AND abg02 = abh08",
                 "   AND abg00='",tm.o_abg00,"'",               #帳別
                 "   AND abg01[1,",g_doc_len,"]= aac01",
                 "   AND abh01[1,",g_doc_len,"]= aac01",
                 "   AND aac16 = 'Y'",
                 "   AND abhconf = 'Y'"

   ELSE
     LET l_sql = "SELECT abg_file.*,abh_file.* FROM abg_file,abh_file,aac_file",
                 " WHERE abg00 = abh00 ",
                 "   AND abg01 = abh07",
                 "   AND abg02 = abh08",
                 "   AND abg00='",tm.o_abg00,"'",                   #帳別
                 "   AND abg01[1,",g_doc_len,"]='",tm.o_abg01,"'",   #單別
                 "   AND abg01[1,",g_doc_len,"]= aac01",
                 "   AND abh01[1,",g_doc_len,"]= aac01",
                 "   AND aac16 = 'Y'",
                 "   AND abhconf = 'Y'"
   END IF

     #傳票日期
     IF tm.b_abg06 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg06  >= '",tm.b_abg06,"'",
                                  " AND abh021 >= '",tm.b_abg06,"'"
     END IF
     IF tm.e_abg06 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg06  <= '",tm.e_abg06,"'",
                                  " AND abh021 <= '",tm.e_abg06,"'"
     END IF
    #---------------------------------CHI-CB0015---------------------(S)
    #傳票編號
     IF tm.b_abg01 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg01 >= '",tm.b_abg01,"'",
                                  " AND abh01 >= '",tm.b_abg01,"'"
     END IF
     IF tm.e_abg01 IS NOT NULL THEN
        LET l_sql = l_sql CLIPPED," AND abg01 <= '",tm.e_abg01,"'",
                                  " AND abh01 <= '",tm.e_abg01,"'"
     END IF
    #---------------------------------CHI-CB0015---------------------(E)

     LET l_sql = l_sql CLIPPED," ORDER BY abg01"

     PREPARE p801_p1_2 FROM l_sql
     DECLARE p801_c1_2 CURSOR WITH HOLD FOR p801_p1_2

     LET l_abh01 = ' '                                #MOD-C90116 add
     FOREACH p801_c1_2 INTO sr.*,sr1.*
        IF g_success='N' THEN
          LET g_totsuccess='N'
          LET g_success='Y'
        END IF
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('abg00',tm.o_abg00,'foreach:',SQLCA.sqlcode,1)
           LET g_success ='N'
           EXIT FOREACH
	      END IF

#######2.carry ?
        LET l_count = 0
       #FUN-C40112-Mark Begin---
       #SELECT COUNT(*) INTO l_count FROM aba_file
       # WHERE aba16 = tm.n_abg00
       #   AND aba17 = sr1.abh01
       #FUN-C40112-Mark End-----

       #FUN-C40112-Add Begin---
        SELECT COUNT(*) INTO l_count FROM aba_file LEFT OUTER JOIN abm_file
            #ON aba00 = abm02 AND aba01 = abm03 AND aba01 = abm06
            ON aba00 = abm02 AND aba01 = abm03 #CHI-CB0057 mod
         WHERE abm05 = tm.n_abg00
           AND abm06 = sr1.abh01
       #FUN-C40112-Add End-----
        IF l_count = 0 THEN
           LET g_showmsg = sr1.abh00,"/",sr1.abh01
           CALL s_errmsg('abh00,abh01',g_showmsg,'','agl-518',1)
           LET g_success = 'N'
        END IF

      #-----------------------MOD-C90116-----------------------(s)
       LET l_post = ' '
       #--MOD-CB0235 mark -start-- 
       #SELECT abapost INTO l_post FROM aba_file
       # WHERE aba16 = tm.n_abg00
       #   AND aba17 = sr1.abh01
       #--MOD-CB0235 mark -end----

       #--MOD-CB0235 start--
       SELECT abapost INTO l_post FROM aba_file LEFT OUTER JOIN abm_file
           ON aba00 = abm05 AND aba01 = abm06  
        WHERE abm05 = tm.n_abg00
          AND abm06 = sr1.abh01
       #--MOD-CB0235 end----
       IF l_post='Y' THEN
          LET g_totsuccess = 'N'
          IF cl_null(l_abh01) OR sr1.abh01 <> l_abh01 THEN
             LET g_showmsg = sr1.abh00,"/",sr1.abh01
             CALL s_errmsg('abh00,abh01',g_showmsg,sr1.abh01,'agl-208',1)
             LET l_abh01 = sr1.abh01
             CONTINUE FOREACH
          ELSE
             LET l_abh01 = sr1.abh01
             CONTINUE FOREACH
          END IF
       END IF
      #-----------------------MOD-C90116-----------------------(E)
      #--CHI-C90001 start---
      LET l_count =0 
      IF g_compare='Y' THEN
          LET l_tag05=''    
          SELECT tag05 INTO l_tag05
            FROM tag_file 
           WHERE tag01 = YEAR(sr1.abh021) 
             AND tag02 = tm.o_abg00 
             AND tag03 = sr1.abh03
             AND tagacti = 'Y' 
             AND tag06 = '1'   
          SELECT COUNT(*) INTO l_count FROM aag_file
           WHERE aag00= tm.n_abg00
             AND aag01= l_tag05
             AND aagacti = 'Y'   
          IF l_count =0 THEN
             LET g_showmsg = tm.n_abg00 CLIPPED,"/",sr1.abh01 CLIPPED,"/",sr1.abh03 CLIPPED      
             CALL s_errmsg('abh00,abh01,abh03',g_showmsg,'','agl-229',1)  
             LET g_success='N'                    
             LET l_tag05 = sr1.abh03
          END IF
      ELSE
          LET l_tag05 = sr1.abh03
      END IF
      #--CHI-C90001  end--
    #kemu abh_file
       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
              aag20,aag222,
              aag21,aag23,                              #TQC-BC0169
              aag31,aag311,aag32,aag321,aag33,aag331,
             #aag34,aag341,aag35,aag351,aag36,aag361    #TQC-BC0056
              aag34,aag341,aag05                        #TQC-BC0056
         INTO l_aag15_1,l_aag151_1,l_aag16_1,l_aag161_1,l_aag17_1,
              l_aag171_1,l_aag18_1,l_aag181_1,l_aag20_1,l_aag222_1,
              l_aag21_1,l_aag23_1,                      #TQC-BC0169
              l_aag31_1,l_aag311_1,l_aag32_1,l_aag321_1,l_aag33_1,
              l_aag331_1,l_aag34_1,l_aag341_1,l_aag05_1 #l_aag35_1,l_aag351_1,   #TQC-BC0056
             #l_aag36_1,l_aag361_1                      #TQC-BC0056
          FROM aag_file
        WHERE aag00   = tm.o_abg00
          AND aag01   = sr1.abh03
          AND aagacti = 'Y'

       SELECT aag15,aag151,aag16,aag161,aag17,aag171,aag18,aag181,
              aag20,aag222,
              aag21,aag23,                              #TQC-BC0169
              aag31,aag331,aag32,aag321,aag33,aag331,
             #aag34,aag341,aag35,aag351,aag36,aag361    #TQC-BC0056
              aag34,aag341,aag05                        #TQC-BC0056
         INTO l_aag15_2,l_aag151_2,l_aag16_2,l_aag161_2,l_aag17_2,
              l_aag171_2,l_aag18_2,l_aag181_2,l_aag20_2,l_aag222_2,
              l_aag21_2,l_aag23_2,                      #TQC-BC0169
              l_aag31_2,l_aag311_2,l_aag32_2,l_aag321_2,l_aag33_2,
              l_aag331_2,l_aag34_2,l_aag341_2,l_aag05_2#l_aag35_2,l_aag351_2,  #TQC-BC0056
             #l_aag36_2,l_aag361_2                     #TQC-BC0056
         FROM aag_file
        WHERE aag00   = tm.n_abg00
          #AND aag01   = sr1.abh03  #CHI-C90001 mark
          AND aag01   = l_tag05     #CHI-C90001 mod
          AND aagacti = 'Y'

#--CHI-C90001 mark--移到前面做
#       LET l_count = 0
#       SELECT COUNT(*) INTO l_count FROM aag_file
#        WHERE aag00   = tm.n_abg00
#         AND aag01   = sr1.abh03
#          AND aagacti = 'Y'
#        IF l_count = 0 THEN
#          #LET g_showmsg = tm.n_abg00,"/",sr1.abh03  #TQC-C60199
#           LET g_showmsg = tm.n_abg00 CLIPPED,"/",sr1.abh03 CLIPPED   #TQC-C60199
#           CALL s_errmsg('abg00,abh03',g_showmsg,'','agl-229',1)
#           LET g_success = 'N'
#        END IF
#--CHI-C90001 mark---

       IF cl_null(l_aag15_1 ) THEN LET l_aag15_1 =' '   END IF
        IF cl_null(l_aag151_1) THEN LET l_aag151_1 =' '  END IF
        IF cl_null(l_aag16_1 ) THEN LET l_aag16_1  =' '  END IF
        IF cl_null(l_aag161_1) THEN LET l_aag161_1 =' '  END IF
        IF cl_null(l_aag17_1 ) THEN LET l_aag17_1  =' '  END IF
        IF cl_null(l_aag171_1) THEN LET l_aag171_1 =' '  END IF
        IF cl_null(l_aag18_1 ) THEN LET l_aag18_1  =' '  END IF
        IF cl_null(l_aag181_1) THEN LET l_aag181_1 =' '  END IF
        IF cl_null(l_aag20_1 ) THEN LET l_aag20_1  =' '  END IF
        IF cl_null(l_aag222_1) THEN LET l_aag222_1 =' '  END IF

        #TQC-BC0169--Begin--
        IF cl_null(l_aag21_1 ) THEN LET l_aag21_1  =' '  END IF
        IF cl_null(l_aag23_1 ) THEN LET l_aag23_1  =' '  END IF
        #TQC-BC0169--End--

        IF cl_null(l_aag31_1 ) THEN LET l_aag31_1  =' '  END IF
        IF cl_null(l_aag311_1) THEN LET l_aag311_1 =' '  END IF
        IF cl_null(l_aag32_1 ) THEN LET l_aag32_1  =' '  END IF
        IF cl_null(l_aag321_1) THEN LET l_aag321_1 =' '  END IF
        IF cl_null(l_aag33_1 ) THEN LET l_aag33_1  =' '  END IF
        IF cl_null(l_aag331_1) THEN LET l_aag331_1 =' '  END IF
        IF cl_null(l_aag34_1 ) THEN LET l_aag34_1  =' '  END IF
        IF cl_null(l_aag341_1) THEN LET l_aag341_1 =' '  END IF
       #TQC-BC0056--Begin--
        IF cl_null(l_aag05_1 ) THEN LET l_aag05_1  =' '  END IF
       #IF cl_null(l_aag35_1 ) THEN LET l_aag35_1  =' '  END IF
       #IF cl_null(l_aag351_1) THEN LET l_aag351_1 =' '  END IF
       #IF cl_null(l_aag36_1 ) THEN LET l_aag36_1  =' '  END IF
       #IF cl_null(l_aag361_1) THEN LET l_aag361_1 =' '  END IF
       #TQC-BC0056---End---
        IF cl_null(l_aag15_2) THEN LET l_aag15_2 =' '   END IF
        IF cl_null(l_aag151_2) THEN LET l_aag151_2 =' '  END IF
        IF cl_null(l_aag16_2) THEN LET l_aag16_2  =' '  END IF
        IF cl_null(l_aag161_2) THEN LET l_aag161_2 =' '  END IF
        IF cl_null(l_aag17_2) THEN LET l_aag17_2  =' '  END IF
        IF cl_null(l_aag171_2) THEN LET l_aag171_2 =' '  END IF
        IF cl_null(l_aag18_2) THEN LET l_aag18_2  =' '  END IF
        IF cl_null(l_aag181_2) THEN LET l_aag181_2 =' '  END IF
        IF cl_null(l_aag20_2) THEN LET l_aag20_2  =' '  END IF
        IF cl_null(l_aag222_2) THEN LET l_aag222_2 =' '  END IF
 
        #TQC-BC0169--Begin--
        IF cl_null(l_aag21_2 ) THEN LET l_aag21_2  =' '  END IF
        IF cl_null(l_aag23_2 ) THEN LET l_aag23_2  =' '  END IF
        #TQC-BC0169--End-- 

        IF cl_null(l_aag31_2) THEN LET l_aag31_2  =' '  END IF
        IF cl_null(l_aag311_2) THEN LET l_aag311_2 =' '  END IF
        IF cl_null(l_aag32_2) THEN LET l_aag32_2  =' '  END IF
        IF cl_null(l_aag321_2) THEN LET l_aag321_2 =' '  END IF
        IF cl_null(l_aag33_2) THEN LET l_aag33_2  =' '  END IF
        IF cl_null(l_aag331_2) THEN LET l_aag331_2 =' '  END IF
        IF cl_null(l_aag34_2) THEN LET l_aag34_2  =' '  END IF
        IF cl_null(l_aag341_2) THEN LET l_aag341_2 =' '  END IF
       #TQC-BC0056--Begin--
        IF cl_null(l_aag05_2) THEN LET l_aag05_2  =' '  END IF
       #IF cl_null(l_aag35_2) THEN LET l_aag35_2  =' '  END IF
       #IF cl_null(l_aag351_2) THEN LET l_aag351_2 =' '  END IF
       #IF cl_null(l_aag36_2) THEN LET l_aag36_2  =' '  END IF
       #IF cl_null(l_aag361_2) THEN LET l_aag361_2 =' '  END IF
       #TQC-BC0056---End---
        IF l_aag15_1  = l_aag15_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag15"
           CALL s_errmsg('abg00,abh03,aag15',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag151_1 =l_aag151_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag151"
           CALL s_errmsg('abg00,abh03,aag151',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag16_1  =l_aag16_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag16"
           CALL s_errmsg('abg00,abh03,aag16',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag161_1 =l_aag161_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag161"
           CALL s_errmsg('abg00,abh03,aag161',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag17_1  =l_aag17_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag17"
           CALL s_errmsg('abg00,abh03,aag17',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag171_1 =l_aag171_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag171"
           CALL s_errmsg('abg00,abh03,aag171',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag18_1  =l_aag18_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag11"
           CALL s_errmsg('abg00,abh03,aag18',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag181_1 =l_aag181_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag181"
           CALL s_errmsg('abg00,abh03,aag181',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag20_1  =l_aag20_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag20"
           CALL s_errmsg('abg00,abh03,aag20',g_showmsg,'','agl-520',1)
           LET g_success = 'N'
        END IF
        IF l_aag222_1 =l_aag222_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag222"
           CALL s_errmsg('abg00,abh03,aag222',g_showmsg,'','agl-521',1)
           LET g_success = 'N'
        END IF

        #TQC-BC0169--Begin--
        IF l_aag21_1  =l_aag21_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag21"
           CALL s_errmsg('abg00,abh03,aag21',g_showmsg,'','agl024',1)
           LET g_success = 'N'
        END IF
        IF l_aag23_1 =l_aag23_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag23"
           CALL s_errmsg('abg00,abh03,aag23',g_showmsg,'','agl1025',1)
           LET g_success = 'N'
        END IF
        #TQC-BC0169--End--

        IF l_aag31_1  =l_aag31_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag31"
           CALL s_errmsg('abg00,abh03,aag31',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag311_1 =l_aag311_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag311"
           CALL s_errmsg('abg00,abh03,aag311',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag32_1  =l_aag32_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag32"
           CALL s_errmsg('abg00,abh03,aag32',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag321_1 =l_aag321_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag321"
           CALL s_errmsg('abg00,abg03,aag321',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag33_1  =l_aag33_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag33"
           CALL s_errmsg('abg00,abh03,aag33',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag331_1 =l_aag331_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag331"
           CALL s_errmsg('abg00,abh03,aag331',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag34_1  =l_aag34_2  THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag34"
           CALL s_errmsg('abg00,abh03,aag34',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
        IF l_aag341_1 =l_aag341_2 THEN ELSE
           LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag341"
           CALL s_errmsg('abg00,abh03,aag341',g_showmsg,'','agl-519',1)
           LET g_success = 'N'
        END IF
       #TQC-BC0056--Begin--
       #IF l_aag35_1  =l_aag35_2  THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag35"
       #   CALL s_errmsg('abg00,abh03,aag35',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #IF l_aag351_1 =l_aag351_2 THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag351"
       #   CALL s_errmsg('abg00,abh03,aag351',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #IF l_aag36_1  =l_aag36_2  THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag36"
       #   CALL s_errmsg('abg00,abh03,aag36',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #IF l_aag361_1 =l_aag361_2 THEN ELSE
       #   LET g_showmsg = tm.o_abg00,"/",sr1.abh03,"/aag361"
       #   CALL s_errmsg('abg00,abh03,aag361',g_showmsg,'','agl-519',1)
       #   LET g_success = 'N'
       #END IF
       #TQC-BC0056---End---
       #TQC-BC0056--Begin---
       #判斷部門管理
        IF l_aag05_1 <> l_aag05_2  THEN
           LET g_showmsg = tm.o_abg00,"/",sr.abg03,"/aag051"
          #CALL s_errmsg('abg00,abg03,aag051',g_showmsg,'','agl1020',1)   #CHI-C90001 mark
           CALL s_errmsg('abg00,abg03,aag05',g_showmsg,'','agl1020',1)    #CHI-C90001
           LET g_success = 'N'
        END IF
       #TQC-BC0056---End---
######delete
           DELETE FROM abh_file WHERE abh00 = tm.n_abg00
                                  AND abh01 = sr1.abh01
                                  AND abh02 = sr1.abh02
                                  AND abh06 = sr1.abh06
                                  AND abh07 = sr1.abh07
                                  AND abh08 = sr1.abh08

        LET l_abh.* = sr1.*
        LET l_abh.abh00 = tm.n_abg00

        LET l_aaa13 = NULL
        SELECT aaa13 INTO l_aaa13 FROM aaa_file
         WHERE aaa01=tm.n_abg00
        IF cl_null(l_aaa13) OR l_aaa13 = 'N' THEN
           LET g_showmsg = tm.n_abg00
           CALL s_errmsg('abg00',g_showmsg,'','agl-516',1)
           LET g_success = 'N'        
           CONTINUE FOREACH 
        END IF
                
       #LET l_abh.abh021= g_today                   #MOD-C90116 mark
        LET l_abh.abh07 = sr.abg01
        LET l_abh.abh08 = sr.abg02
       #LET l_abh.abhconf = 'N'   #MOD-D20007 mark
       #MOD-D20007--
        SELECT aba19 INTO l_abh.abhconf FROM aba_file
         WHERE aba00 = l_abh.abh00 AND aba01= l_abh.abh01
       #MOD-D20007--

        #CHI-C20009--Begin--
        #來源帳別幣別與目地帳別幣別相同時,傳票金額不需重算
        SELECT aaa03 INTO l_aaa03_1 FROM aaa_file WHERE aaa01 = tm.o_abg00
        SELECT aaa03 INTO l_aaa03_2 FROM aaa_file WHERE aaa01 = tm.n_abg00
        SELECT azi04 INTO l_azi04 FROM azi_file WHERE azi01 = l_aaa03_2
        IF l_aaa03_1 <> l_aaa03_2 THEN
           #匯率抓取應依參數設定aza19(1.月平均 2.每日),
           #再決定要抓取每月或每日匯率                #M:銀行中價匯率
           CALL s_curr3(l_aaa03_2,l_abg.abg06,'M') RETURNING l_abb25
           LET l_abg.abg072 = l_abb25 * l_abg.abg072
           LET l_abh.abh09 = l_abb25 * l_abh.abh09
           LET l_abg.abg071 = cl_digcut(l_abg.abg072,l_azi04)
           LET l_abh.abh09 = cl_digcut(l_abh.abh09,l_azi04)
        ELSE    #CHI-C20009--End--
           IF cl_null(l_abh.abh09) THEN LET l_abh.abh09 = 0 END IF
        END IF  #CHI-C20009
########update abg072
        UPDATE abg_file
           SET abg072= abg072 + l_abh.abh09         #CHI-C20009 #MOD-CA0063 remark
          #SET abg072= l_abg.abg072 + l_abh.abh09   #CHI-C20009 #MOD-CA0063 mark
         WHERE abg00 = tm.n_abg00
           AND abg01 = sr.abg01
           AND abg02 = sr.abg02
############

         LET l_abh.abh11 = sr1.abh11
         LET l_abh.abh12 = sr1.abh12
         LET l_abh.abh13 = sr1.abh13
         LET l_abh.abh14 = sr1.abh14
         LET l_abh.abh31 = sr1.abh31
         LET l_abh.abh32 = sr1.abh32
         LET l_abh.abh33 = sr1.abh33
         LET l_abh.abh34 = sr1.abh34
        #TQC-BC0056--Begin Mark--
        #LET l_abh.abh35 = sr1.abh35
        #LET l_abh.abh36 = sr1.abh36
        #TQC-BC0056---End Mark---
         LET l_abh.abh03 = l_tag05     #CHI-C90001

         IF cl_null(l_abh.abh11) THEN LET l_abh.abh11 = "" END IF
         IF cl_null(l_abh.abh12) THEN LET l_abh.abh12 = "" END IF
         IF cl_null(l_abh.abh13) THEN LET l_abh.abh13 = "" END IF
         IF cl_null(l_abh.abh14) THEN LET l_abh.abh14 = "" END IF
         IF cl_null(l_abh.abh31) THEN LET l_abh.abh31 = "" END IF
         IF cl_null(l_abh.abh32) THEN LET l_abh.abh32 = "" END IF
         IF cl_null(l_abh.abh33) THEN LET l_abh.abh33 = "" END IF
         IF cl_null(l_abh.abh34) THEN LET l_abh.abh34 = "" END IF
        #TQC-BC0056--Begin Mark--
        #IF cl_null(l_abh.abh35) THEN LET l_abh.abh35 = "" END IF
        #IF cl_null(l_abh.abh36) THEN LET l_abh.abh36 = "" END IF
         LET l_abh.abh35 = ""
         LET l_abh.abh36 = ""
        #TQC-BC0056---End Mark---

        INSERT INTO abh_file VALUES(l_abh.*)
        IF STATUS THEN
           CALL s_errmsg('insert abh_file','','',STATUS,1)
           LET g_success = 'N'
        END IF
    END FOREACH

    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
END FUNCTION
