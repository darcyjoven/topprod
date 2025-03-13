# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: aoou701.4gl
# Descriptions...: 編號缺號檢查表
# Date & Author..: 92/10/15 By Roger
# Modify.........: 94/01/24 By Wenni-報表格式
# Modify.........: 98/03/02 By Carol -- bug:3027
# Modify.........: No.+122 010515 by linda add 序時檢查功能
# Modify.........: No.FUN-560106  by day    單據編號修改
# Modify.........: No.MOD-640295 06/04/10 by Echo 執行後,結果程式被踢出
# Modify.........: No.FUN-680102 06/08/28 By zdyllq 類型轉換
# Modify.........: No.TQC-6A0090 06/11/01 By baogui表頭無公司名稱 
# Modify.........: No.FUN-750095 07/06/06 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.TQC-770029 07/08/17 By Smapmin 多打印缺號
# Modify.........: No.MOD-930171 09/03/30 By liuxqa 打印時，報EXECUTE insert_prep的錯誤。
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   離開MAIN時沒有cl_used(1)和cl_used(2) 
# Modify.........: No:MOD-BA0183 11/10/25 By Smapmin 拿掉不必要的程式
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No:MOD-CC0025 13/03/14 By Elise 將71,72拿掉，因與31,32重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    bno,eno       LIKE type_file.chr20,          #No.FUN-680102 VARCHAR(20),
    bdate,edate   LIKE type_file.dat,            #No.FUN-680102 DATE,
    d      LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),
    tr_seq LIKE type_file.num5,           #No.FUN-680102 SMALLINT,
    y      LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(1),
    p_row,p_col LIKE type_file.num5       #No.FUN-680102 SMALLINT
 
DEFINE   g_i    LIKE type_file.num5       #count/index for any purpose        #No.FUN-680102 SMALLINT
#No.FUN-750095 -- begin --
DEFINE g_sql      STRING
DEFINE l_table    STRING
DEFINE g_str      STRING
#No.FUN-750095 -- end --
 
MAIN
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AOO")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
    LET g_rlang = g_lang
    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         LET p_row = 3 LET p_col = 28
    ELSE LET p_row = 3 LET p_col = 10
    END IF
    OPEN WINDOW aoou701_w AT p_row,p_col WITH FORM "aoo/42f/aoou701"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
    CALL cl_opmsg('z')
 
#No.FUN-750095 -- begin --
    LET g_sql = "title_tag.type_file.chr1,",
                "s.type_file.chr50,",
                "r.type_file.chr1"
    LET l_table = cl_prt_temptable('aoou701',g_sql) CLIPPED
    IF l_table = -1 THEN EXIT PROGRAM END IF
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-BB0047 add
       EXIT PROGRAM
    END IF
#No.FUN-750095 -- end --
 
    CALL u701_i()
    CLOSE WINDOW aoou701_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION u701_i()
   DEFINE   bd,ed             LIKE type_file.num5            #No.FUN-680102 SMALLINT
   DEFINE   tr_fld,tr_file    LIKE type_file.chr20           #No.FUN-680102 VARCHAR(20)
   DEFINE   tr_date           LIKE type_file.chr20           #No.FUN-680102 VARCHAR(20)
   DEFINE   tr_no,pre_no      LIKE type_file.chr20           #No.FUN-680102 VARCHAR(20)
   DEFINE   beg_no,miss_no    LIKE type_file.chr20           #No.FUN-680102 VARCHAR(20)
   DEFINE   l_sql             STRING  #No.FUN-580092 HCN  
   DEFINE   l_str             LIKE type_file.chr50         #No.FUN-750095
   DEFINE   s                 LIKE type_file.chr50         #No.FUN-680102  VARCHAR(35) 
   DEFINE   l_name            LIKE type_file.chr20         #No.FUN-680102  VARCHAR(20)
   DEFINE   l_name1           LIKE type_file.chr20         #No.FUN-680102  VARCHAR(20)
   DEFINE   i,i1,i2,l_n       LIKE type_file.num10         #No.FUN-680102  INTEGER
   DEFINE   l_za05            LIKE za_file.za05            #No.FUN-680102  VARCHAR(40)
#   DEFINE   h,n,l_y           LIKE type_file.chr1          #No.FUN-680102  VARCHAR(01) #No.MOD-930171 mark
   DEFINE   l_m,l_y           LIKE type_file.chr1          #No.FUN-680102  VARCHAR(01)  #No.MOD-930171 mod
   DEFINE   l_date ,no_date   LIKE type_file.dat           #No.FUN-680102  DATE 
   DEFINE   l_no              LIKE type_file.chr5          #No.FUN-680102  VARCHAR(5)     #No.FUN-560106
   DEFINE   l_cmd             LIKE type_file.chr1000       #No.FUN-680102CHAR(100)
   DEFINE   old_no            LIKE type_file.chr5          #No.FUN-680102CHAR(5)    #No.FUN-560106
#  LET bd = 5 LET ed = 10                 #No.FUN-560106
   LET bd = g_no_sp LET ed = g_no_ep                 #No.FUN-560106
   LET bdate=null
   LET edate=null
   LET d = 'N'
   LET y = 'Y'
 
   WHILE TRUE
      INPUT BY NAME tr_seq,bno,eno,bd,ed,bdate,edate,d,y WITHOUT DEFAULTS
 
       ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
 
         AFTER FIELD tr_seq
            CASE
               WHEN tr_seq = 1
                  LET tr_fld = "ima01"
                  LET tr_file = "ima_file"
                  LET tr_date ="@@@@@"
               WHEN tr_seq = 2
                  LET tr_fld = "imn01"
                  LET tr_file = "imn_file"
                  LET tr_date ="@@@@@"
               WHEN tr_seq = 3
                  LET tr_fld = "imo01"
                  LET tr_file = "imo_file"
                  LET tr_date ="imo02"
               WHEN tr_seq = 4
                  LET tr_fld = "imq01"
                  LET tr_file = "imq_file"
                  LET tr_date ="@@@@@"
               WHEN tr_seq = 5
                  LET tr_fld = "sfk01"
                  LET tr_file = "sfk_file"
                  LET tr_date ="sfk02"
               WHEN tr_seq = 6
                  LET tr_fld = "sfb01"
                  LET tr_file = "sfb_file"
                  LET tr_date ="sfb81"
               WHEN tr_seq = 7
                  LET tr_fld = "pia01"
                  LET tr_file = "pia_file"
                  LET tr_date ="pia12"
               WHEN tr_seq = 8
                  LET tr_fld = "imm01"
                  LET tr_file = "imm_file"
                  LET tr_date ="imm02"
               WHEN tr_seq = 11
                  LET tr_fld = "bmr01"
                  LET tr_file = "bmr_file"
                  LET tr_date ="bmr02"
               WHEN tr_seq = 12
                  LET tr_fld = "bmx01"
                  LET tr_file = "bmx_file"
                  LET tr_date ="bmx02"
               WHEN tr_seq = 21
                  LET tr_fld = "pmk01"
                  LET tr_file = "pmk_file"
                  LET tr_date ="pmk04"
               WHEN tr_seq = 22
                  LET tr_fld = "pmm01"
                  LET tr_file = "pmm_file"
                  LET tr_date ="pmm04"
               WHEN tr_seq = 23
                  LET tr_fld = "rva01"
                  LET tr_file = "rva_file"
                  LET tr_date ="rva06"
               WHEN tr_seq = 24
                  LET tr_fld = "rvu01"
                  LET tr_file = "rvu_file"
                  LET tr_date ="rvu03"
               WHEN tr_seq = 31
                  LET tr_fld = "apa01"
                  LET tr_file = "apa_file"
                  LET tr_date ="apa02"
               WHEN tr_seq = 32
                  LET tr_fld = "apf01"
                  LET tr_file = "apf_file"
                  LET tr_date ="apf02"
               WHEN tr_seq = 41
                  LET tr_fld = "oqt01"
                  LET tr_file = "oqt_file"
                  LET tr_date ="oqt02"
               WHEN tr_seq = 42
                  LET tr_fld = "oea01"
                  LET tr_file = "oea_file"
                  LET tr_date ="oea02"
               WHEN tr_seq = 43
                  LET tr_fld = "oga01"
                  LET tr_file = "oga_file"
                  LET tr_date ="oga02"
               WHEN tr_seq = 44
                  LET tr_fld = "oha01"
                  LET tr_file = "oha_file"
                  LET tr_date ="oha02"
               WHEN tr_seq = 45
                  LET tr_fld = "apk01"
                  LET tr_file = "apk_file"
                  LET tr_date ="@@@@@"
               WHEN tr_seq = 46
                  LET tr_fld = "oma01"
                  
LET tr_file = "oma_file"
                  LET tr_date ="oma02"
               WHEN tr_seq = 51
                  LET tr_fld = "aba01"
                  LET tr_file = "aba_file"
                  LET tr_date ="aba02"
               WHEN tr_seq = 52
                  LET tr_fld = "aba11"
                  LET tr_file = "aba_file"
                  LET tr_date ="aba02"
               WHEN tr_seq = 61
                  LET tr_fld = "tlf026"
                  LET tr_file= "tlf_file"
                  LET tr_date ="tlf06"
               WHEN tr_seq = 62
                  LET tr_fld = "tlf036"
                  LET tr_file= "tlf_file"
                  LET tr_date ="tlf06"
               #MOD-CC0025 add start -----
               #WHEN tr_seq = 71
               #   LET tr_fld = "apa01"
               #   LET tr_file = "apa_file"
               #   LET tr_date ="apa02"
               #WHEN tr_seq = 72
               #   LET tr_fld = "apf01"
               #   LET tr_file = "apf_file"
               #   LET tr_date ="apf02"
               #MOD-CC0025 add start -----
               WHEN tr_seq = 73
                  LET tr_fld = "ala01"
                  LET tr_file = "ala_file"
                  LET tr_date ="ala08"
               WHEN tr_seq = 74
                  LET tr_fld = "alf01"
                  LET tr_file = "alf_file"
                  LET tr_date ="@@@@@"
               OTHERWISE
                  NEXT FIELD tr_seq
            END CASE
#           DISPLAY BY NAME tr_fld
            IF tr_seq = '52' THEN
               LET bd =2  LET ed=10
#No.FUN-560106-begin
#           ELSE
#              LET bd = 5 LET ed = 10
#No.FUN-560106-end
            END IF
            DISPLAY BY NAME bd,ed
 
         AFTER FIELD bno
            IF cl_null(bno) THEN
               NEXT FIELD bno
            END IF
#...........99/03/02 Modify by Carol tr_seq='52' 須做單號check:aba11(integer)
            LET l_y = 'Y'
            IF tr_seq = '52' THEN
               LET l_n=LENGTH(bno)
               FOR i = 1 TO l_n
                  IF bno[i,i] NOT MATCHES '[0-9]' THEN
                     LET l_y = 'N'
                  END IF
               END FOR
            END IF
            IF l_y='N' THEN
               NEXT FIELD bno
            END IF
            IF eno IS NULL THEN
               LET eno = bno DISPLAY BY NAME eno
            END IF
 
         AFTER FIELD eno
            IF cl_null(eno) OR eno < bno  THEN
               NEXT FIELD eno END IF
            LET l_y = 'Y'
            IF tr_seq = '52' THEN
               LET l_n=LENGTH(eno)
               FOR i = 1 TO l_n
                  IF eno[i,i] NOT MATCHES '[0-9]' THEN
                     LET l_y = 'N'
                  END IF
               END FOR
            END IF
            IF l_y='N' THEN
               NEXT FIELD eno
            END IF
#..........................................................................
 
         AFTER FIELD bd
            IF bd IS NULL THEN
               NEXT FIELD bd
            END IF
#...........99/03/02 Modify by Carol ------ 須做check以防欄位計算時 error
            IF tr_seq = '52' AND bd < 2  THEN
               NEXT FIELD bd
            END IF
#..........................................................................
 
         AFTER FIELD ed
            IF ed IS NULL THEN
               NEXT FIELD ed
            END IF
#...........99/03/02 Modify by Carol tr_seq='52'須做check以防欄位計算時 error
#No.FUN-560106-begin
#           IF ed < 3  THEN
            IF ed < g_no_sp  THEN
#No.FUN-560106-end
               NEXT FIELD ed
            END IF
#..........................................................................
         AFTER FIELD edate
            IF NOT cl_null(bdate) AND NOT cl_null(edate) THEN
               IF edate < bdate THEN
                  NEXT FIELD edate
               END IF
            END IF
 
         AFTER FIELD d
            IF d NOT MATCHES "[YN]" THEN
               NEXT FIELD d
            END IF
 
         AFTER FIELD y
            IF y NOT MATCHES "[YN]" THEN
               NEXT FIELD y
            END IF
 
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG = 0 RETURN
      END IF
      CALL cl_wait()
#--->modify by Wenni on 94/01/24
      #MOD-640295
      #SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aoou701'
      #IF g_len = 0 OR g_len IS NULL THEN
      #   LET g_len = 80
      #END IF
      #FOR g_i = 1 TO g_len
      #   LET g_dash[g_i,g_i] = '='
      #END FOR
      #END MOD-640295
#----------------------------------------
      LET l_sql = "SELECT ",tr_fld," FROM ",tr_file," WHERE ",
                   tr_fld," BETWEEN '",bno,"' AND '",eno,"'"
      IF tr_date <>'@@@@@' AND NOT cl_null(bdate) THEN
         LET l_sql=l_sql CLIPPED," AND ",tr_date CLIPPED,">='",bdate,"' "
      END IF
      IF tr_date <>'@@@@@' AND NOT cl_null(edate) THEN
         LET l_sql=l_sql CLIPPED," AND ",tr_date CLIPPED,"<='",edate,"' "
      END IF
      LET l_sql=l_sql CLIPPED, " GROUP BY ",tr_fld," ORDER BY ",tr_fld,""
      PREPARE u701_p1 FROM l_sql
      DECLARE u701_c1 CURSOR FOR u701_p1
      LET l_n = 0
      LET pre_no = NULL
#     LET l_name = 'aoou701.out'
#No.FUN-750095 -- begin --
#      CALL cl_outnam('aoou701') RETURNING l_name
#      #MOD-640295
#      IF g_len = 0 OR g_len IS NULL THEN
#         LET g_len = 80
#      END IF
#      FOR g_i = 1 TO g_len
#         LET g_dash[g_i,g_i] = '='
#      END FOR
#      #END MOD-640295
#      START REPORT u701_rep TO l_name
#No.FUN-750095 -- end --
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang     #TQC-6A0090
      CALL cl_del_data(l_table)       #No.FUN-750095
 
      FOREACH u701_c1 INTO tr_no
         LET l_n = l_n + 1
         MESSAGE 'tr:',tr_no CLIPPED,'no:',l_n  USING '#######'
         IF NOT cl_numchk(tr_no[bd,ed],ed-bd+1) THEN
            LET s = 'non-numeric number: ',tr_no
#No.FUN-750095 -- begin --
#            OUTPUT TO REPORT u701_rep(s,'n')
            LET l_m='n'     #No.MOD-930171 add
#            EXECUTE insert_prep USING '0',s,'n' #No.MOD-930171 mark
            EXECUTE insert_prep USING '0',s,l_m #No.MOD-930171 mark
            IF STATUS THEN
               CALL cl_err("execute insert_prep:",STATUS,1)
               EXIT FOREACH
            END IF
#No.FUN-750095 -- end --
            LET pre_no = NULL
            CONTINUE FOREACH
         END IF
      #  IF pre_no IS NULL OR tr_no[1,bd-1] != pre_no[1,bd-1] THEN
         IF pre_no IS NULL THEN
            #IF pre_no IS NOT NULL THEN
                #LET s = '         End  no  : ',pre_no
                #LET s = pre_no
                #OUTPUT TO REPORT u701_rep(s)
            #END IF
            #LET s = '         Begin no : ',tr_no
#            LET s = ':',tr_no         #No.FUN-750095
            LET s = tr_no         #No.FUN-750095
 #          OUTPUT TO REPORT u701_rep(s,'h')     #bugno:4883
            LET beg_no = tr_no
#bugno:4883---------------------
            IF tr_no[bd,ed] != bno[bd,ed] THEN
               #-----TQC-770029--------- 
               #LET pre_no = tr_no
               #LET pre_no[ed-2,ed]='001'
               LET pre_no = bno
               #-----END TQC-770029-----  
#No.FUN-750095 -- begin --
#               OUTPUT TO REPORT u701_rep(pre_no,'n')
               LET l_m='n'       #No.MOD-930171 add 
#               EXECUTE insert_prep USING '0',pre_no,'n'  #No.MOD-930171 mark
               EXECUTE insert_prep USING '0',pre_no,l_m   #No.MOD-930171 mod
               IF STATUS THEN
                  CALL cl_err("execute insert_prep:",STATUS,1)
                  EXIT FOREACH
               END IF
#No.FUN-750095 -- end --
            END IF
--------------------------------
            LET pre_no = tr_no
 #          CONTINUE FOREACH        #bugno:4883
         END IF
         IF tr_no[1,bd-1] != pre_no[1,bd-1] THEN
            LET pre_no[bd,ed]=tr_no[bd,ed]
            LET pre_no[ed-2,ed]='000'    #欄位check( ed-2 > 0 )
         END IF
         LET i = tr_no[bd,ed] - pre_no[bd,ed]
         IF i > 1 THEN
            LET i1 = pre_no[bd,ed] +1
            LET i2 = tr_no[bd,ed]  -1
            IF (i2 - i1 > 10) THEN
               LET s = i1 USING '&&&&&&&&&&&&&&&&&&&&'
                  LET miss_no = tr_no[1,bd-1], s[20-(ed-bd),20]
                 #LET l_sql = '        miss from : ',miss_no
#                  LET l_sql = miss_no        #No.FUN-750095
                  LET l_str = miss_no        #No.FUN-750095
                  LET s = i2 USING '&&&&&&&&&&&&&&&&&&&&'
                  LET miss_no = tr_no[1,bd-1], s[20-(ed-bd),20]
                 #LET l_sql = l_sql CLIPPED,' to : ',miss_no
#                  LET l_sql = l_sql CLIPPED,' 至 ',miss_no      #No.FUN-750095
                  LET l_str = l_str CLIPPED,' 至 ',miss_no      #No.FUN-750095
#No.FUN-750095 -- begin --
#                  OUTPUT TO REPORT u701_rep(l_sql,'n')
                  LET l_m='n'      #No.MOD-930171 add
#                  EXECUTE insert_prep USING '0',l_str,'n'  #No.MOD-930171 mark
                  EXECUTE insert_prep USING '0',l_str,l_m   #No.MOD-930171 mod
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOREACH
                  END IF
#No.FUN-750095 -- end --
               ELSE
                  FOR i = i1 TO i2
                     LET s = i USING '&&&&&&&&&&&&&&&&&&&&'
                     LET miss_no = tr_no[1,bd-1], s[20-(ed-bd),20]
                     #LET s = '          miss no : ',miss_no
                     LET s = miss_no
#No.FUN-750095 -- begin --
#                     OUTPUT TO REPORT u701_rep(s,'n')
                     LET l_m='n'    #No.MOD-930171 add
#                     EXECUTE insert_prep USING '0',s,'n'   #No.MOD-930171 mark
                     EXECUTE insert_prep USING '0',s,l_m    #No.MOD-930171 mod
                     IF STATUS THEN
                        CALL cl_err("execute insert_prep:",STATUS,1)
                        EXIT FOREACH
                     END IF
#No.FUN-750095 -- end --
                  END FOR
            END IF
         END IF
         IF y = 'Y' THEN
            #LET s = '                  : ',tr_no
#No.FUN-750095 -- begin --
#            LET s = ':',tr_no
#            OUTPUT TO REPORT u701_rep(s,'h')
            LET s = tr_no
            LET l_m='h'     #No.MOD-930171 add
#            EXECUTE insert_prep USING '0',s,'h'  #No.MOD-930171 mark
            EXECUTE insert_prep USING '0',s,l_m   #No.MOD-930171 mod
            IF STATUS THEN
               CALL cl_err("execute insert_prep:",STATUS,1)
               EXIT FOREACH
            END IF
#No.FUN-750095 -- end --
         END IF
         LET pre_no = tr_no
      END FOREACH
 
      #LET s = '         End   no : ',pre_no
      #LET s = pre_no
      #OUTPUT TO REPORT u701_rep(s)
#      FINISH REPORT u701_rep     #No.FUN-750095
#----------------------------------------
     #No.+122 010515 by linda add 序時檢查
      IF tr_date <>'@@@@@' AND d='Y' THEN
         LET l_sql = "SELECT ",tr_fld,",",tr_date," FROM ",tr_file," WHERE ",
                      tr_fld," BETWEEN '",bno,"' AND '",eno,"'"
         IF NOT cl_null(bdate) THEN
            LET l_sql=l_sql CLIPPED," AND ",tr_date CLIPPED,">='",bdate,"' "
         END IF
         IF  NOT cl_null(edate) THEN
            LET l_sql=l_sql CLIPPED," AND ",tr_date CLIPPED,"<='",edate,"' "
         END IF
         LET l_sql=l_sql CLIPPED," GROUP BY ",tr_fld,",",tr_date," ORDER BY ",tr_fld,""
         PREPARE u701_p2 FROM l_sql
         DECLARE u701_c2 CURSOR FOR u701_p2
         LET l_n = 0
         LET pre_no = NULL
         LET l_name1 = l_name CLIPPED,"x"
         LET l_date =null
         LET old_no='@@@'
#         START REPORT u701_rep2 TO l_name1     #No.FUN-750095
 
         FOREACH u701_c2 INTO tr_no,no_date
            LET l_no = tr_no[1,g_doc_len]    #No.FUN-560106
            IF l_no <> old_no THEN
               LET l_date = no_date
               LET old_no = l_no
            END IF
            IF no_date < l_date THEN
               LET s=tr_no CLIPPED," ",no_date
#No.FUN-750095 -- begin --
#               OUTPUT TO REPORT u701_rep2(s,'n')
               LET l_m='n'     #No.MOD-930171 add
#               EXECUTE insert_prep USING '1',s,'n'   #No.MOD-930171 mark
               EXECUTE insert_prep USING '1',s,l_m    #No.MOD-930171 mod
               IF STATUS THEN
                  CALL cl_err("execute insert_prep:",STATUS,1)
                  EXIT FOREACH
               END IF
#No.FUN-750095 -- end --
            ELSE
               LET l_date = no_date
               IF y = 'Y' THEN
#No.FUN-750095 -- begin --
#                  LET s=":",tr_no CLIPPED," ",no_date
#                  OUTPUT TO REPORT u701_rep2(s,'h')
                  LET s=tr_no CLIPPED," ",no_date
                  LET l_m='h'      #No.MOD-930171 add
#                  EXECUTE insert_prep USING '1',s,'h'  #No.MOD-930171 mark
                  EXECUTE insert_prep USING '1',s,l_m   #No.MOD-930171 mod
                  IF STATUS THEN
                     CALL cl_err("execute insert_prep:",STATUS,1)
                     EXIT FOREACH
                  END IF
#No.FUN-750095 -- end --
               END IF
            END IF
         END FOREACH
 
#         FINISH REPORT u701_rep2      #No.FUN-750095 -- begin --
         #LET l_cmd="cat ",l_name1,">>",l_name   #MOD-BA0183
         #RUN l_cmd   #MOD-BA0183
      END IF
      #No.+122 010515 end---
      ERROR ""
#No.FUN-750095 -- begin --
#      CALL cl_prt(l_name,' ','1',g_len)
     LET g_str = bno,";",eno,";",bdate,";",edate,";",tr_seq,";",d,";",y
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('aoou701','aoou701',g_sql,g_str)
#No.FUN-750095 -- end --
   END WHILE
 
END FUNCTION
 
#No.FUN-750095 -- begin --
#REPORT u701_rep(s,r) # r='h' 表示有此編號  r='n' 表示無此編號
#DEFINE s LIKE type_file.chr50          #No.FUN-680102 VARCHAR(35) 
#DEFINE r LIKE type_file.chr1,           #No.FUN-680102 VARCHAR(01)
#       l_trailer_sw    LIKE type_file.chr1
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    FORMAT
#    PAGE HEADER
#        PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED  #TQC-6A0090
#        PRINT COLUMN 30,g_x[1] CLIPPED
#        PRINT ' '
#        PRINT COLUMN 01,g_x[2] CLIPPED,g_today,' ',TIME,
#              COLUMN 30,g_x[46] CLIPPED,bdate,"-",edate
#     #  PRINT COLUMN 30,g_x[11] CLIPPED,bno
#        PRINT COLUMN 01,g_x[13] CLIPPED,tr_seq USING '<<';
#        CASE tr_seq
#             WHEN '1'  PRINT COLUMN 13,g_x[15] CLIPPED;
#             WHEN '2'  PRINT COLUMN 13,g_x[16] CLIPPED;
#             WHEN '3'  PRINT COLUMN 13,g_x[17] CLIPPED;
#             WHEN '4'  PRINT COLUMN 13,g_x[18] CLIPPED;
#             WHEN '5'  PRINT COLUMN 13,g_x[19] CLIPPED;
#             WHEN '6'  PRINT COLUMN 13,g_x[20] CLIPPED;
#             WHEN '7'  PRINT COLUMN 13,g_x[21] CLIPPED;
#             WHEN '8'  PRINT COLUMN 13,g_x[22] CLIPPED;
#             WHEN '11' PRINT COLUMN 13,g_x[23] CLIPPED;
#             WHEN '12' PRINT COLUMN 13,g_x[24] CLIPPED;
#             WHEN '21' PRINT COLUMN 13,g_x[25] CLIPPED;
#             WHEN '22' PRINT COLUMN 13,g_x[26] CLIPPED;
#             WHEN '23' PRINT COLUMN 13,g_x[27] CLIPPED;
#             WHEN '24' PRINT COLUMN 13,g_x[28] CLIPPED;
#             WHEN '31' PRINT COLUMN 13,g_x[29] CLIPPED;
#             WHEN '32' PRINT COLUMN 13,g_x[30] CLIPPED;
#             WHEN '41' PRINT COLUMN 13,g_x[31] CLIPPED;
#             WHEN '42' PRINT COLUMN 13,g_x[32] CLIPPED;
#             WHEN '43' PRINT COLUMN 13,g_x[33] CLIPPED;
#             WHEN '44' PRINT COLUMN 13,g_x[34] CLIPPED;
#             WHEN '45' PRINT COLUMN 13,g_x[35] CLIPPED;
#             WHEN '46' PRINT COLUMN 13,g_x[36] CLIPPED;
#             WHEN '51' PRINT COLUMN 13,g_x[37] CLIPPED;
#             WHEN '52' PRINT COLUMN 13,g_x[38] CLIPPED;
#             WHEN '61' PRINT COLUMN 13,g_x[39] CLIPPED;
#             WHEN '62' PRINT COLUMN 13,g_x[40] CLIPPED;
#             WHEN '71' PRINT COLUMN 13,g_x[41] CLIPPED;
#             WHEN '72' PRINT COLUMN 13,g_x[42] CLIPPED;
#             WHEN '73' PRINT COLUMN 13,g_x[43] CLIPPED;
#             WHEN '74' PRINT COLUMN 13,g_x[44] CLIPPED;
#             OTHERWISE EXIT CASE
#         END CASE
#
#       #PRINT COLUMN 30,g_x[12] CLIPPED,eno,
#        PRINT COLUMN 26," ",g_x[11] CLIPPED,bno CLIPPED," ",
#              g_x[12] CLIPPED,eno CLIPPED,
#              COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#        PRINT g_dash[1,g_len]
#        SKIP 1 LINE
#        PRINT COLUMN 20,g_x[11] CLIPPED,bno
#        SKIP 1 LINE
#        LET l_trailer_sw = 'y'    #TQC-6A0090 add
#
#        ON EVERY ROW
#           IF y = 'Y' THEN # 是否列印存在編號
#              IF r = 'n' THEN # 缺號
#                 PRINT COLUMN 24,g_x[14] CLIPPED,s
#              ELSE
#                 PRINT COLUMN 28,s CLIPPED
#              END IF
#           ELSE
#                PRINT COLUMN 24,g_x[14] CLIPPED,s
#           END IF
#
#        ON LAST ROW
#           PRINT ' '
#           PRINT COLUMN 20,g_x[12] CLIPPED,eno
#           SKIP 1 LINE
#           PRINT g_dash[1,g_len]  #add     TQC-6A0090                                                                               
#           LET l_trailer_sw = 'n'         #add      TQC-6A0090                                                                      
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-8), g_x[7] CLIPPED  #TQC-6A0090
##TQC-6A0090--begin                                                                                                                  
#        PAGE TRAILER                                                                                                                
#           IF l_trailer_sw = 'y' THEN                                                                                               
#              PRINT g_dash[1,g_len]                                                                                                 
#              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED                                                         
#           ELSE                                                                                                                     
#              SKIP 2 LINE                                                                                                           
#           END IF                                                                                                                   
##TQC-6A0090--end
#END REPORT
#
##No.+122 010515 by linda add 序時檢查
#REPORT u701_rep2(s,r) # r='h' 表示有此編號  r='n' 表示無此編號
#DEFINE s LIKE ima_file.ima01           #No.FUN-680102CHAR(40)
#DEFINE r LIKE type_file.chr1           #No.FUN-680102CHAR(01)
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    FORMAT
#    PAGE HEADER
#        PRINT COLUMN 30,g_x[45] CLIPPED
#        PRINT ' '
#        PRINT COLUMN 01,g_x[2] CLIPPED,g_today,' ',TIME,
#              COLUMN 30,g_x[46] CLIPPED,bdate,"-",edate
#     #  PRINT COLUMN 30,g_x[11] CLIPPED,bno
#        PRINT COLUMN 01,g_x[13] CLIPPED,tr_seq USING '<<';
#        CASE tr_seq
#             WHEN '1'  PRINT COLUMN 13,g_x[15] CLIPPED;
#             WHEN '2'  PRINT COLUMN 13,g_x[16] CLIPPED;
#             WHEN '3'  PRINT COLUMN 13,g_x[17] CLIPPED;
#             WHEN '4'  PRINT COLUMN 13,g_x[18] CLIPPED;
#             WHEN '5'  PRINT COLUMN 13,g_x[19] CLIPPED;
#             WHEN '6'  PRINT COLUMN 13,g_x[20] CLIPPED;
#             WHEN '7'  PRINT COLUMN 13,g_x[21] CLIPPED;
#             WHEN '8'  PRINT COLUMN 13,g_x[22] CLIPPED;
#             WHEN '11' PRINT COLUMN 13,g_x[23] CLIPPED;
#             WHEN '12' PRINT COLUMN 13,g_x[24] CLIPPED;
#             WHEN '21' PRINT COLUMN 13,g_x[25] CLIPPED;
#             WHEN '22' PRINT COLUMN 13,g_x[26] CLIPPED;
#             WHEN '23' PRINT COLUMN 13,g_x[27] CLIPPED;
#             WHEN '24' PRINT COLUMN 13,g_x[28] CLIPPED;
#             WHEN '31' PRINT COLUMN 13,g_x[29] CLIPPED;
#             WHEN '32' PRINT COLUMN 13,g_x[30] CLIPPED;
#             WHEN '41' PRINT COLUMN 13,g_x[31] CLIPPED;
#             WHEN '42' PRINT COLUMN 13,g_x[32] CLIPPED;
#             WHEN '43' PRINT COLUMN 13,g_x[33] CLIPPED;
#             WHEN '44' PRINT COLUMN 13,g_x[34] CLIPPED;
#             WHEN '45' PRINT COLUMN 13,g_x[35] CLIPPED;
#             WHEN '46' PRINT COLUMN 13,g_x[36] CLIPPED;
#             WHEN '51' PRINT COLUMN 13,g_x[37] CLIPPED;
#             WHEN '52' PRINT COLUMN 13,g_x[38] CLIPPED;
#             WHEN '61' PRINT COLUMN 13,g_x[39] CLIPPED;
#             WHEN '62' PRINT COLUMN 13,g_x[40] CLIPPED;
#             WHEN '71' PRINT COLUMN 13,g_x[41] CLIPPED;
#             WHEN '72' PRINT COLUMN 13,g_x[42] CLIPPED;
#             WHEN '73' PRINT COLUMN 13,g_x[43] CLIPPED;
#             WHEN '74' PRINT COLUMN 13,g_x[44] CLIPPED;
#             OTHERWISE EXIT CASE
#         END CASE
#
#     #  PRINT COLUMN 30,g_x[12] CLIPPED,eno,
#        PRINT COLUMN 26," ",g_x[11] CLIPPED,bno CLIPPED," ",
#              g_x[12] CLIPPED,eno CLIPPED,
#              COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
#        PRINT g_dash[1,g_len]
#        SKIP 1 LINE
#        PRINT COLUMN 20,g_x[11] CLIPPED,bno
#        SKIP 1 LINE
#
#        ON EVERY ROW
#           IF y = 'Y' THEN # 是否列印存在編號
#              IF r = 'n' THEN # 缺號
#                 PRINT COLUMN 24,g_x[47] CLIPPED,COLUMN 30,s
#              ELSE
#                 PRINT COLUMN 30,s CLIPPED
#              END IF
#           ELSE
#                PRINT COLUMN 24,g_x[47] CLIPPED,COLUMN 30,s
#           END IF
#
#        ON LAST ROW
#           PRINT ' '
#           PRINT COLUMN 20,g_x[12] CLIPPED,eno
#           SKIP 1 LINE
#END REPORT
#No.FUN-750095 -- end --
#No.+122 010515 end---
#Patch....NO.TQC-610036 <001> #
