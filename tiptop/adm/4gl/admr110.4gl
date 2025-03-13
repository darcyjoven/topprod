# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: admr110.4gl
# Descriptions...: 客戶信用餘額分析表
# Input parameter:
# Date & Author..: 02/07/26 By Kitty
# Modify.........: No.FUN-4C0099 05/01/17 By kim 報表轉XML功能
# Modify.........: No.MOD-580164 05/08/17 By Rosayu 當已用額度< 0 時,可用額度=已用額度-授信額度
# Modify.........: No.MOD-590082 05/09/13 By Rosayu 1.已用額度(sr.occ63a),可用額度(sr.occ63b)資料顛倒
#                                                   2.畫面警訊改成可用額度百分比低於_____%
#                                                   3.可用額度百分比=(可用額度/授信額度)*100%
#                                                   4. 原程式段要修正低於可用額度百分比才印出
#                                                   5.百分比要可以印負的
# Modify.........: No.FUN-680097 06/08/28 By chen 類型轉換
# Modify.........: No.FUN-690111 06/10/16 By bnlent cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0100 06/10/27 By czl l_time轉g_time
# Modify.........: No.FUN-750027 07/07/16 By TSD.Ken CR
# Modify.........: No.FUN-750121 07/11/06 By Sarah 1.QBE選項加入信用評等,QBE欄位全加上開窗功能
#                                                  2.INPUT增加"信用額度可超出百分比"
#                                                  3.信用評等空白，會一直跳出視窗警告，請修改成新作法顯示(使用單一視窗show array)
#                                                  4.報表結果的"百分比"欄位加寬(目前若超出會產生*)
# Modify.........: No.MOD-960259 09/06/30 By Smapmin 授信額度要包含超出率
 
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD		 	       #Print condition RECORD
            wc       STRING,                   #Where Condition        #No.TQC-630166  
            d        LIKE type_file.num5,      #可用額度百分比低於     #No.FUN-680097 SMALLINT
            more     LIKE type_file.chr1       #特殊列印條件           #No.FUN-680097 VARCHAR(01)
           END RECORD 
DEFINE l_amt1        LIKE oeb_file.oeb14
DEFINE g_i           LIKE type_file.num5       #count/index for any purpose        #No.FUN-680097 SMALLINT
DEFINE l_table       STRING                    #FUN-750027 add
DEFINE g_str         STRING                    #FUN-750027 add
DEFINE g_sql         STRING                    #FUN-750027 add
DEFINE g_msg         LIKE type_file.chr1000    #FUN-750121 add
DEFINE g_show_msg    DYNAMIC ARRAY OF RECORD   #FUN-750121 add
            occ01    LIKE occ_file.occ01,
            occ02    LIKE occ_file.occ02,
            occ18    LIKE occ_file.occ18,
            ze01     LIKE ze_file.ze01,
            ze03     LIKE ze_file.ze03
                     END RECORD
DEFINE g_occ01       LIKE occ_file.occ01       #FUN-750121 add
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ADM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690111
 
   #str FUN-750027 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql="occ01.occ_file.occ01,",     
             "occ02.occ_file.occ02,",
             "occ631.occ_file.occ631,",
             "occ63.occ_file.occ63,",
             "occ63a.occ_file.occ63,",
             "occ63b.occ_file.occ63,",
             "azi04.azi_file.azi04,",
             "occ61.occ_file.occ61,",   #FUN-750121 add
             "occ64.occ_file.occ64"     #FUN-750121 add
 
   LET l_table = cl_prt_temptable('admr110',g_sql) CLIPPED   # 產生Temp Table
   IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"   #FUN-7510121 add ?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
   #------------------------------ CR (1) ------------------------------#
   #end FUN-750027 add
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   LET tm.d     = ARG_VAL(8)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   LET g_rpt_name = ARG_VAL(12)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'
      THEN CALL r110_tm(0,0)	
      ELSE CALL r110()		
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
END MAIN
 
FUNCTION r110_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE p_row,p_col    LIKE type_file.num5         #No.FUN-680097 SMALLINT
DEFINE l_cmd          LIKE type_file.chr1000      #No.FUN-680097 VARCHAR(400)
 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 11 END IF
   OPEN WINDOW r110_w AT p_row,p_col WITH FORM "adm/42f/admr110"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.more  = 'N'
   LET g_pdate  = g_today
   LET g_rlang  = g_lang
   LET g_bgjob  = 'N'
   LET g_copies = '1'
   IF tm.d is NULL THEN LET tm.d = '100' END IF   #MOD-590082 add
 
   WHILE TRUE
     #CONSTRUCT BY NAME tm.wc ON occ01,occ03         #FUN-750121 mark
      CONSTRUCT BY NAME tm.wc ON occ01,occ03,occ61   #FUN-750121 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #str FUN-750121 add
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(occ01)   #客戶編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_occ'
                    LET g_qryparam.state= 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO occ01
                    NEXT FIELD occ01
               WHEN INFIELD(occ03)   #客戶分類
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_oca'
                    LET g_qryparam.state= 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO occ03
                    NEXT FIELD occ03
               WHEN INFIELD(occ61)   #信用評等
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = 'q_ocg'
                    LET g_qryparam.state= 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO occ61
                    NEXT FIELD occ61
            END CASE
         #end FUN-750121 add
 
         ON ACTION locale
           #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
 
      IF tm.wc=" 1=1 " THEN
         CALL cl_err(' ','9046',0)
         CONTINUE WHILE
      END IF
 
      INPUT BY NAME tm.d,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD d
            IF cl_null(tm.d) THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD more
            IF tm.more NOT MATCHES'[YN]' THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
################################################################################
# START genero shell script ADD
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
         ON ACTION CONTROLG 
            CALL cl_cmdask()	# Command execution
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file	#get exec cmd (fglgo xxxx)
                WHERE zz01='admr110'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('admr110','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,		#(at time fglgo xxxx p1 p2 p3)
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.d CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",     #No.FUN-570264
                        " '",g_rep_clas CLIPPED,"'",     #No.FUN-570264
                        " '",g_template CLIPPED,"'",     #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('admr110',g_time,l_cmd)   #Execute cmd at later time
         END IF
         CLOSE WINDOW r110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL r110()
      ERROR ""
   END WHILE
   CLOSE WINDOW r110_w
END FUNCTION
 
FUNCTION r110()
   DEFINE l_name     LIKE type_file.chr20, 	          #External(Disk) file name        #No.FUN-680097 VARCHAR(20)
#         l_time     LIKE type_file.chr8,                 #No.FUN-6A0100
          l_sql      STRING,		                  #RDSQL STATEMENT  
          l_za05     LIKE type_file.chr1000,              #No.FUN-680097 VARCHAR(40)
          l_rr       LIKE type_file.num5,                 #No.FUN-680097 SMALLINT
          l_msg      STRING,                              #FUN-750121 add
          l_msg2     STRING,                              #FUN-750121 add
          lc_gaq03   LIKE gaq_file.gaq03,                 #FUN-750121 add
          sr         RECORD
                     occ01     LIKE    occ_file.occ01,    #客戶編號
                     occ02     LIKE    occ_file.occ02,    #客戶簡稱
                     occ631    LIKE    occ_file.occ631,   #授信幣別
                     occ63     LIKE    occ_file.occ63,    #授信額度
                     occ63a    LIKE    occ_file.occ63,    #可用額度
                     occ63b    LIKE    occ_file.occ63,    #已用額度
                     azi04     LIKE    azi_file.azi04,    #金額小數位數
                     occ61     LIKE    occ_file.occ61,    #信用評等   #FUN-750121 add
                     occ64     LIKE    occ_file.occ64     #可超出率   #FUN-750121 add
                     END RECORD
 
   #str FUN-750027 add
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table)
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 =  g_prog  #FUN-750027 ad
   #------------------------------ CR (2) ------------------------------#
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
      #LET tm.wc = tm.wc clipped," AND fakuser = '",g_user,"'"   #MOD-960259
   #      LET tm.wc = tm.wc clipped," AND occuser = '",g_user,"'"   #MOD-960259
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
      #LET tm.wc = tm.wc clipped," AND oeagrup MATCHES '",g_grup CLIPPED,"*'"   #MOD-960259
   #      LET tm.wc = tm.wc clipped," AND occgrup MATCHES '",g_grup CLIPPED,"*'"   #MOD-960259
   #   END IF
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #LET tm.wc = tm.wc clipped," AND oeagrup IN ",cl_chk_tgrup_list()   #MOD-960259
   #      LET tm.wc = tm.wc clipped," AND occgrup IN ",cl_chk_tgrup_list()   #MOD-960259
   #   END IF
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('occuser', 'occgrup')
   #End:FUN-980030
 
   #LET l_sql = "SELECT occ01,occ02,occ631,occ63,0,0,azi04,occ61,occ64 ",   #FUN-750121 add occ61,occ64   #MOD-960259
   LET l_sql = "SELECT occ01,occ02,occ631,occ63*(100+occ64)/100,0,0,azi04,occ61,occ64 ",   #FUN-750121 add occ61,occ64   #MOD-960259
               "  FROM occ_file,azi_file",
               " WHERE occ631=azi01",
               "   AND occ62 ='Y'",
               "   AND ",tm.wc CLIPPED
   PREPARE r110_p1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
   DECLARE r110_c1 CURSOR FOR r110_p1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('declare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690111
      EXIT PROGRAM
   END IF
 
   LET l_amt1 = 0
   LET g_pageno = 0
   CALL g_show_msg.clear()   #FUN-750121 add
   FOREACH r110_c1 INTO sr.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      CALL s_ccc_logerr()    #FUN-750121 add
      LET g_occ01=sr.occ01   #FUN-750121 add
      CALL s_ccc(sr.occ01,'3','') RETURNING sr.occ63a    #客戶信用查核
      LET sr.occ63b=sr.occ63-sr.occ63a
      #str FUN-750121 add
      IF r110_err_ana(g_showmsg) THEN
 
      END IF
      IF g_errno = 'N' THEN
         CALL cl_getmsg('axm-270',g_rlang) RETURNING g_msg
      END IF
      #end FUN-750121 add
      #MOD-590082 mark
      ##MOD-580165 add
      ##IF sr.occ63a < 0 THEN
      ##    LET sr.occ63b=sr.occ63a-sr.occ63
      ##ELSE
      ##    LET sr.occ63b=sr.occ63-sr.occ63a
      ##END IF
      ##MOD-580165(end)
      #IF (sr.occ63b/sr.occ63)*100 >= tm.d THEN    #超過警訊百分比的資料才列印
      #   OUTPUT TO REPORT r110_rep(sr.*)
      #END IF
      #MOD-590082 add
      IF (sr.occ63a/sr.occ63)*100 <= tm.d THEN     #低於可用額度百分比的資料才>
         EXECUTE insert_prep USING sr.*
      END IF
      #MOD-590082 end
   END FOREACH
 
   #str FUN-750121 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
      IF g_show_msg.getlength()>0 THEN
         CALL cl_get_feldname("occ01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("occ18",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
         CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
         CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
      END IF
   END IF   #TQC-730022
   #end FUN-750121 add
 
   #str FUN-750027 add
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
   #是否列印選擇條件
   IF g_zz05 = 'Y' THEN
     #CALL cl_wcchp(tm.wc,'occ01,occ03') RETURNING tm.wc        #FUN-750121 mark
      CALL cl_wcchp(tm.wc,'occ01,occ03,occ61') RETURNING tm.wc  #FUN-750121
      LET g_str = tm.wc
   END IF
   LET g_str = g_str CLIPPED,";",tm.d USING '<<<'
   CALL cl_prt_cs3('admr110','admr110',l_sql,g_str)
   #------------------------------ CR (4) ------------------------------#
END FUNCTION
 
#str FUN-750121 add
FUNCTION r110_err_ana(ls_showmsg)
   DEFINE ls_showmsg  STRING
   DEFINE lc_ze01     LIKE ze_file.ze01
   DEFINE lc_occ02    LIKE occ_file.occ02
   DEFINE lc_occ18    LIKE occ_file.occ18
   DEFINE li_newerrno LIKE type_file.num5
   DEFINE ls_tmpstr   STRING
 
   IF cl_null(ls_showmsg) THEN
      RETURN FALSE
   END IF
 
   LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                         ls_showmsg.getLength())
   IF ls_showmsg.getIndexOf("||",1) THEN
      LET lc_ze01 = ls_showmsg.subString(1,ls_showmsg.getIndexOf("||",1)-1)
      LET ls_showmsg = ls_showmsg.subString(ls_showmsg.getIndexOf("||",1)+2,
                                            ls_showmsg.getLength())
   ELSE
      LET lc_ze01 = ls_showmsg.trim()
      LET ls_showmsg = ""
   END IF
 
   SELECT occ02,occ18 INTO lc_occ02,lc_occ18 FROM occ_file
    WHERE occ01=g_occ01
 
   LET li_newerrno = g_show_msg.getLength() + 1
   LET g_show_msg[li_newerrno].occ01 = g_occ01
   LET g_show_msg[li_newerrno].occ02 = lc_occ02
   LET g_show_msg[li_newerrno].occ18 = lc_occ18
   LET g_show_msg[li_newerrno].ze01  = lc_ze01
   CALL cl_getmsg(lc_ze01,g_lang) RETURNING ls_tmpstr
   LET g_show_msg[li_newerrno].ze03  = ls_showmsg.trim(),ls_tmpstr.trim()
   LET li_newerrno = g_show_msg.getLength()
   DISPLAY li_newerrno
   RETURN TRUE
 
END FUNCTION
#end FUN-750121 add
 
#REPORT r110_rep(sr)
#   DEFINE l_last_sw  LIKE type_file.chr1,             #No.FUN-680097 VARCHAR(1)
#          l_aa       LIKE oeb_file.oeb14,
#          l_amt      LIKE oeb_file.oeb14,
#          sr         RECORD
#                      occ01     LIKE    occ_file.occ01,    #客戶編號
#                      occ02     LIKE    occ_file.occ02,    #客戶簡稱
#                      occ631    LIKE    occ_file.occ631,   #授信幣別
#                      occ63     LIKE    occ_file.occ63,    #授信額度
#                      occ63a    LIKE    occ_file.occ63,    #可用額度
#                      occ63b    LIKE    occ_file.occ63,    #已用額度
#                      azi04     LIKE    azi_file.azi04     #
#                     END RECORD
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.occ01,sr.occ631
#
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno=g_pageno+1
#      LET pageno_total=PAGENO USING '<<<','/pageno'
#      PRINT g_head CLIPPED,pageno_total
#      PRINT
#      PRINT g_dash
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#      PRINT g_dash1
#      LET l_last_sw = 'n'
# 
#   AFTER GROUP OF sr.occ631
#      PRINT COLUMN g_c[31],sr.occ02,
#            COLUMN g_c[32],sr.occ631,
#            COLUMN g_c[33],cl_numfor(GROUP SUM(sr.occ63),33,sr.azi04),  #金額
#            COLUMN g_c[34],cl_numfor(GROUP SUM(sr.occ63b),34,sr.azi04),  #金額 #MOD-590082
#            COLUMN g_c[35],cl_numfor(GROUP SUM(sr.occ63a),35,sr.azi04),  #金額 #MOD-590082
#            COLUMN g_c[36],GROUP SUM(sr.occ63a)/GROUP SUM(sr.occ63)*100 USING '---&.&&%' #MOD-590082
# 
#   ON LAST ROW
#      IF g_zz05 = 'Y' THEN       # (80)-70,140,210,280   /   (132)-120,240,300
#         PRINT g_dash
#         #No.TQC-630166 --start--
##        IF tm.wc[001,80] > ' ' THEN			# for 132
##  	     PRINT g_x[8] CLIPPED,tm.wc[001,80] CLIPPED 
##        END IF
#         CALL cl_prt_pos_wc(tm.wc)
#         #No.TQC-630166 ---end---
#      END IF
#      PRINT g_dash
#      LET l_last_sw = 'y'
#      PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED
# 
#   PAGE TRAILER
#      IF l_last_sw = 'n' THEN
#         PRINT g_dash
#         PRINT g_x[4],g_x[5] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED
#      ELSE 
#         SKIP 2 LINE
#      END IF
#END REPORT
