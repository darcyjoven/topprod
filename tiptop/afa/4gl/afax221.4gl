# Prog. Version..: '5.30.07-13.05.30(00002)'     #
#
# Pattern name...: afax221.4gl
# Descriptions...: 部門資產清冊
# Date & Author..: 96/06/10 By Charis
# Modify.........: No.CHI-480001 04/08/11 By Danny  增加資產停用選項
# Modify.........: No.FUN-510035 05/01/19 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-610033 06/01/09 By Smapmin 增加營運中心開窗功能
# Modify.........: No.MOD-640529 06/04/24 By Smapmin 增加本幣成本欄位
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-690113 06/10/13 By yjkhero cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-7B0138 07/12/03 By Lutingting 轉為用Crystal Report 輸出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-AC0100 10/12/11 By Carrier 成本调整成faj14+faj141
# Modify.........: No:MOD-AC0120 10/12/14 By Dido 取消 0 狀態,並檢核須為不折舊才可呈現 
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark 
# Modify.........: NO:MOD-BB0326 11/12/01 By Dido 數量調整為 faj17-faj58 
# Modify.........: NO:MOD-CA0201 12/10/29 By suncx 新增保管部門，保管人，主類型，存放位置，財務編號開窗挑選
# Modify.........: No.FUN-CA0132 12/11/05 By zhangweib CR轉XtraGrid
# Modify.........: No.FUN-D40129 13/05/24 By yangtt 添加小數取位欄位
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD                  # Print condition RECORD
              wc      LIKE type_file.chr1000,     # Where condition       #No.FUN-680070 VARCHAR(1000)
              s       LIKE type_file.chr3,          # Order by sequence       #No.FUN-680070 VARCHAR(3)
              t       LIKE type_file.chr3,          # Eject sw       #No.FUN-680070 VARCHAR(3)
              c       LIKE type_file.chr1,          # No.CHI-480001       #No.FUN-680070 VARCHAR(1)
              more    LIKE type_file.chr1           # Input more condition(Y/N)       #No.FUN-680070 VARCHAR(1)
              END RECORD
 
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
   DEFINE g_str      STRING                  #No.FUN-7B0138
   DEFINE g_sql      STRING                  #No.FUN-7B0138
   DEFINE l_table    STRING                  #No.FUN-7B0138
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690113
#No.FUN-7B0138--start
   LET g_sql = "faj02.faj_file.faj02,",
               "faj022.faj_file.faj022,",
               "faj04.faj_file.faj04,",
               "faj06.faj_file.faj06,",
               "faj07.faj_file.faj07,",
               "faj08.faj_file.faj08,",
               "faj17.faj_file.faj17,",
               "faj18.faj_file.faj18,",
               "faj14.faj_file.faj14,",
               "faj19.faj_file.faj19,",
               "gen02.gen_file.gen02,",
               "faj20.faj_file.faj20,",
               "gem02.gem_file.gem02,",
               "faj21.faj_file.faj21,",
               "faf02.faf_file.faf02,",
               "faj22.faj_file.faj22,",
               "faj26.faj_file.faj26,",
               "faj43.faj_file.faj43,",
               "faj43_1.ze_file.ze03,", #No.FUN-CA0132   Add
               "azi04.azi_file.azi04,",    #FUN-D40129
               "l_n1.type_file.num5"       #FUN-D40129
   LET l_table = cl_prt_temptable('afax221',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES (?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,? ,?,?,?)"   #No.FUN-CA0132   Add  ?  #FUN-D40129 add 2?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF
#No.FUN-7B0138--end
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s  = ARG_VAL(8)
   LET tm.t  = ARG_VAL(9)
   LET tm.c  = ARG_VAL(10)                     #No.CHI-480001
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(11)
   LET g_rep_clas = ARG_VAL(12)
   LET g_template = ARG_VAL(13)
   LET g_rpt_name = ARG_VAL(14)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL afax221_tm(0,0)        # Input print condition
      ELSE CALL afax221()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
END MAIN
 
FUNCTION afax221_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE   p_row,p_col   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_cmd         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
 
   LET p_row = 4 LET p_col = 16
 
   OPEN WINDOW afax221_w AT p_row,p_col WITH FORM "afa/42f/afax221"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.s    = '123'
   LET tm.t    = 'Y  '
   LET tm.c    = '0'                         #No.CHI-480001
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   #genero版本default 排序,跳頁,合計值
   LET tm2.s1   = tm.s[1,1]
   LET tm2.s2   = tm.s[2,2]
   LET tm2.s3   = tm.s[3,3]
   LET tm2.t1   = tm.t[1,1]
   LET tm2.t2   = tm.t[2,2]
   LET tm2.t3   = tm.t[3,3]
   IF cl_null(tm2.s1) THEN LET tm2.s1 = ""  END IF
   IF cl_null(tm2.s2) THEN LET tm2.s2 = ""  END IF
   IF cl_null(tm2.s3) THEN LET tm2.s3 = ""  END IF
   IF cl_null(tm2.t1) THEN LET tm2.t1 = "N" END IF
   IF cl_null(tm2.t2) THEN LET tm2.t2 = "N" END IF
   IF cl_null(tm2.t3) THEN LET tm2.t3 = "N" END IF
 
   WHILE TRUE
      CONSTRUCT BY NAME tm.wc ON faj20,faj19,faj04,faj21,faj22,faj02,faj26,faj14
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
     #-----MOD-610033---------
     ON ACTION CONTROLP
        CASE
              WHEN INFIELD(faj22)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_azp"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj22
                   NEXT FIELD faj22
              #MOD-CA0201 add begin-------------------------------------
               WHEN INFIELD(faj20)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gem"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj20
                   NEXT FIELD faj20
               WHEN INFIELD(faj19)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_gen"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj19
                   NEXT FIELD faj19
               WHEN INFIELD(faj04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_fab"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj04
                   NEXT FIELD faj04
               WHEN INFIELD(faj21)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_faf"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj21
                   NEXT FIELD faj21
               WHEN INFIELD(faj02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state = "c"
                   LET g_qryparam.form = "q_faj"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO faj02
                   NEXT FIELD faj02
              #MOD-CA0201 add end---------------------------------------
        END CASE
     #-----END MOD-610033-----
 
 
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
         LET INT_FLAG = 0 CLOSE WINDOW afax221_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0) CONTINUE WHILE
      END IF
      INPUT BY NAME tm2.s1,tm2.s2,tm2.s3,tm2.t1,tm2.t2,tm2.t3,
                    tm.c,tm.more WITHOUT DEFAULTS      #No.CHI-480001
 
         #No.CHI-480001
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD c
            IF cl_null(tm.c) OR tm.c NOT MATCHES "[012]" THEN
               NEXT FIELD FORMONLY.c
            END IF
         #end
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" THEN
               NEXT FIELD FORMONLY.more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies)
               RETURNING g_pdate,g_towhom,g_rlang,g_bgjob,g_time,g_prtway,g_copies
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
         AFTER INPUT
            LET tm.s = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1]
            LET tm.t = tm2.t1,tm2.t2,tm2.t3
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
         LET INT_FLAG = 0 CLOSE WINDOW afax221_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
            
      END IF
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='afax221'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('afax221','9031',1)
         ELSE
            LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                            #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.wc CLIPPED,"'",
                            " '",tm.s CLIPPED,"'",
                            " '",tm.t CLIPPED,"'",
                            " '",tm.c CLIPPED,"'",     #No.CHI-480001
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
            CALL cl_cmdat('afax221',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW afax221_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL afax221()
      ERROR ""
   END WHILE
 
   CLOSE WINDOW afax221_w
END FUNCTION
 
FUNCTION afax221()
   DEFINE l_name    LIKE type_file.chr20,                # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6A0069
          l_sql     LIKE type_file.chr1000,              # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_za05    LIKE za_file.za05,                   #No.FUN-680070 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE type_file.chr21,    #No.FUN-680070 VARCHAR(10)
          sr        RECORD order1 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
                           order2 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
                           order3 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
                           faj02 LIKE faj_file.faj02,    # 財產編號
                           faj022 LIKE faj_file.faj022,  # 財產附號
                           faj04 LIKE faj_file.faj04,    # 財產類別
                           faj06 LIKE faj_file.faj06,    # 中文名稱
                           faj07 LIKE faj_file.faj07,    # 英文名稱
                           faj08 LIKE faj_file.faj08,    # 規格型號
                           faj17 LIKE faj_file.faj17,    # 數量
                           faj18 LIKE faj_file.faj18,    # 單位
                           faj14 LIKE faj_file.faj14,    # 本幣成本   #MOD-640529
                           faj19 LIKE faj_file.faj19,    # 保管人
                           gen02 LIKE gen_file.gen02,    #     姓名
                           faj20 LIKE faj_file.faj20,    # 保管部門
                           gem02 LIKE gem_file.gem02,    # 部門名稱
                           faj21 LIKE faj_file.faj21,    # 存放位置
                           faf02 LIKE faf_file.faf02,    #     名稱
                           faj22 LIKE faj_file.faj22,    # 存放工廠
                           faj26 LIKE faj_file.faj26,    # 入帳日期
                           faj28 LIKE faj_file.faj28,    # 折舊方法   #MOD-AC0120 
                           faj43 LIKE faj_file.faj43
                    END RECORD
   DEFINE l_faj431   LIKE ze_file.ze03   #No.FUN-CA0132   Add
   DEFINE l_n1       LIKE type_file.num5   #FUN-D40129
     CALL cl_del_data(l_table)              #No.FUN-7B0138
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'afax221' #No.FUN-7B0138
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND fajuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND fajgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND fajgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT '','','',",
                 " faj02, faj022, faj04, faj06, faj07,",
                 #" faj08, faj17, faj18, faj19, gen02,",   #MOD-640529
                 #No.MOD-AC0100  --Begin
                 #" faj08, faj17, faj18, faj14, faj19, gen02,",   #MOD-640529
                #" faj08, faj17, faj18, faj14+faj141, faj19, gen02,",        #MOD-BB0326 mark
                 " faj08, faj17-faj58, faj18, faj14+faj141, faj19, gen02,",  #MOD-BB0326
                 #No.MOD-AC0100  --End  
                 " faj20, gem02, faj21, faf02, faj22, faj26, faj28, faj43",     #MOD-AC0120 add faj28
                 "  FROM faj_file,",
                 " OUTER gem_file,OUTER gen_file,OUTER faf_file",
                 " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
                #" AND faj43 not IN ('0','5','6','X')",                         #MOD-AC0120 mark
                #" AND faj43 not IN ('5','6','X')",                             #MOD-AC0120
		 " AND faj_file.faj19=gen_file.gen01 AND faj_file.faj20=gem_file.gem01 ",
		 " AND faj_file.faj21=faf_file.faf01 "
 
     #No.CHI-480001
     IF tm.c = '1' THEN    #停用
        #LET l_sql = l_sql CLIPPED," AND faj105 = 'Y' " #No.FUN-B80081 mark
         LET l_sql = l_sql CLIPPED," AND faj43 = 'Z' "  #No.FUN-B80081 add  
     END IF
     IF tm.c = '0' THEN    #正常使用
        LET l_sql = l_sql CLIPPED,
                    #" AND (faj105 = 'N' OR faj105 IS NULL OR faj105 = ' ') " #No.FUN-B80081 mark
                     " AND faj43 NOT IN ('0','5','6','X','Z')" #No.FUN-B80081 add
     END IF
     #end
 
     PREPARE afax221_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690113
        EXIT PROGRAM
           
     END IF
     DECLARE afax221_curs1 CURSOR FOR afax221_prepare1
 
#     CALL cl_outnam('afax221') RETURNING l_name     #No.FUN-7B0138
#     START REPORT afax221_rep TO l_name             #No.FUN-7B0138 
#     LET g_pageno = 0                               #No.FUN-7B0138 
     FOREACH afax221_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
#No.FUN-7B0138--START--    MARK
     #  FOR g_i = 1 TO 3
     #     CASE WHEN tm.s[g_i,g_i] = '1' LET l_order[g_i] = sr.faj20
     #          WHEN tm.s[g_i,g_i] = '2' LET l_order[g_i] = sr.faj19
     #          WHEN tm.s[g_i,g_i] = '3' LET l_order[g_i] = sr.faj04
     #          WHEN tm.s[g_i,g_i] = '4' LET l_order[g_i] = sr.faj21
     #          WHEN tm.s[g_i,g_i] = '5' LET l_order[g_i] = sr.faj22
     #          WHEN tm.s[g_i,g_i] = '6' LET l_order[g_i] = sr.faj02
     #          WHEN tm.s[g_i,g_i] = '7'
     #               LET l_order[g_i] = sr.faj26 USING 'yyyymmdd'
     #          WHEN tm.s[g_i,g_i] = '8' LET l_order[g_i] = sr.faj14   #MOD-640529
     #          OTHERWISE LET l_order[g_i] = '-'
     #     END CASE
     #  END FOR
     #  LET sr.order1 = l_order[1]
     #  LET sr.order2 = l_order[2]
     #  LET sr.order3 = l_order[3]
     #  OUTPUT TO REPORT afax221_rep(sr.*)
#No.FUN-7B0138-- end  MARK
       #-MOD-AC0120-add-
        IF sr.faj43 = '0' AND sr.faj28 <> '0' THEN
           CONTINUE FOREACH 
        END IF 
       #-MOD-AC0120-end- 
      #No.FUN-CA0132 ---start--- Add
       CASE
          WHEN sr.faj43 = '1' 
             SELECT ze03 INTO l_faj431 FROM ze_file WHERE ze02 = g_lang AND ze01 = 'afa-014'  #   1.資本化
          WHEN sr.faj43 = '2' 
             SELECT ze03 INTO l_faj431 FROM ze_file WHERE ze02 = g_lang AND ze01 = 'afa-057'  #   2.折舊中
          WHEN sr.faj43 = '4' 
             SELECT ze03 INTO l_faj431 FROM ze_file WHERE ze02 = g_lang AND ze01 = 'afa-058'  #   4.折畢
          WHEN sr.faj43 = '7' 
             SELECT ze03 INTO l_faj431 FROM ze_file WHERE ze02 = g_lang AND ze01 = 'afa-059'  #   7.折畢再提
       END CASE
      #No.FUN-CA0132 ---start--- Add
#No.FUN-7B0138--START
       LET l_n1 = 0   #FUN-D40129
       EXECUTE insert_prep USING
          sr.faj02,sr.faj022,sr.faj04,sr.faj06,sr.faj07,sr.faj08,sr.faj17,
          sr.faj18,sr.faj14,sr.faj19,sr.gen02,sr.faj20,sr.gem02,sr.faj21,
          sr.faf02,sr.faj22,sr.faj26,sr.faj43 
#No.FUN-7B0138--END
         ,l_faj431   #No.FUN-CA0132   Add
          ,g_azi04,l_n1   #FUN-D40129
     END FOREACH
#No.FUN-7B0138--start--
###XtraGrid###     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN 
        CALL cl_wcchp(tm.wc,'faj20,faj19,faj04,faj21,faj22,faj02,faj26,faj14')
        RETURNING tm.wc
        LET g_str = tm.wc
     END IF 
###XtraGrid###     LET g_str = g_str,";",tm.s[1,1],";",tm.s[2,2],";",tm.s[3,3],";",
###XtraGrid###                 tm.t[1,1],";",tm.t[2,2],";",tm.t[3,3],";",g_azi04
###XtraGrid###     CALL cl_prt_cs3('afax221','afax221',g_sql,g_str)
    LET g_xgrid.table = l_table    ###XtraGrid###
    LET g_xgrid.order_field = cl_get_order_field(tm.s,"faj20,faj19,faj04,faj21,faj22,faj02,faj26,faj14")
    LET g_xgrid.skippage_field = cl_get_skip_field(tm.s,tm.t,"faj20,faj19,faj04,faj21,faj22,faj02,faj26,faj14")
    LET g_xgrid.condition= tm.wc
    CALL cl_xg_view()    ###XtraGrid###
#No.FUN-7B0138--end
#     FINISH REPORT afax221_rep               #No.FUN-7B0138
 
#     CALL cl_prt(l_name,g_prtway,g_copies,g_len)  #No.FUN-7B0138
END FUNCTION
 
#No.FUN-7B0138--MARK START--
# REPORT afax221_rep(sr)
#   DEFINE l_last_sw    LIKE type_file.chr1,                 #No.FUN-680070 VARCHAR(1)
#          l_sts        LIKE type_file.chr8,                 #No.FUN-680070 VARCHAR(08)
#          sr           RECORD order1 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
#                              order2 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
#                              order3 LIKE type_file.chr21,  #No.FUN-680070 VARCHAR(10)
#                              faj02 LIKE faj_file.faj02,    # 財產編號
#                              faj022 LIKE faj_file.faj022,  # 財產附號
#                              faj04 LIKE faj_file.faj04,    # 財產類別
#                              faj06 LIKE faj_file.faj06,    # 中文名稱
#                              faj07 LIKE faj_file.faj07,    # 英文名稱
#                              faj08 LIKE faj_file.faj08,    # 規格型號
#                              faj17 LIKE faj_file.faj17,    # 數量
#                              faj18 LIKE faj_file.faj18,    # 單位
#                              faj14 LIKE faj_file.faj14,    # 本幣成本   #MOD-640529
#                              faj19 LIKE faj_file.faj19,    # 保管人
#                              gen02 LIKE gen_file.gen02,    #     姓名
#                              faj20 LIKE faj_file.faj20,    # 保管部門
#                              gem02 LIKE gem_file.gem02,    # 部門名稱
#                              faj21 LIKE faj_file.faj21,    # 存放位置
#                              faf02 LIKE faf_file.faf02,    #     名稱
#                              faj22 LIKE faj_file.faj22,    # 存放工廠
#                              faj26 LIKE faj_file.faj26,    # 入帳日期
#                              faj43 LIKE faj_file.faj43
#                       END RECORD
 
#  OUTPUT TOP MARGIN g_top_margin
#         LEFT MARGIN g_left_margin
#         BOTTOM MARGIN g_bottom_margin
#         PAGE LENGTH g_page_line
#  ORDER BY sr.order1,sr.order2,sr.order3,sr.faj20
#  FORMAT
#   PAGE HEADER
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#      LET g_pageno = g_pageno + 1
#      LET pageno_total = PAGENO USING '<<<',"/pageno"
#      PRINT g_head CLIPPED, pageno_total
#      PRINT g_dash[1,g_len]
#      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
#            #g_x[39],g_x[40],g_x[41],g_x[42],g_x[43]   #MOD-640529
#            g_x[39],g_x[40],g_x[41],g_x[44],g_x[42],g_x[43]   #MOD-640529
#      PRINT g_dash1
#      LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.order1
#      IF tm.t[1,1] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order2
#      IF tm.t[2,2] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.order3
#      IF tm.t[3,3] = 'Y' THEN SKIP TO TOP OF PAGE END IF
 
#   BEFORE GROUP OF sr.faj20
#      PRINT COLUMN g_c[31],sr.faj20,
#            COLUMN g_c[32],sr.gem02;
 
#   ON EVERY ROW
#      CASE
#        WHEN sr.faj43 = '1' LET l_sts = g_x[9] clipped
#        WHEN sr.faj43 = '2' LET l_sts = g_x[10] clipped
#        WHEN sr.faj43 = '4' LET l_sts = g_x[11] clipped
#        WHEN sr.faj43 = '7' LET l_sts = g_x[12] clipped
#        OTHERWISE EXIT CASE
#      END CASE
#      PRINT COLUMN g_c[33],sr.gen02,
#            COLUMN g_c[34],sr.faf02,
#            COLUMN g_c[35],sr.faj04,
#            COLUMN g_c[36],sr.faj02,
#            COLUMN g_c[37],sr.faj022,
#            COLUMN g_c[38],sr.faj06,
#            COLUMN g_c[39],sr.faj08,
#            COLUMN g_c[40],cl_numfor(sr.faj17,40,0),
#            COLUMN g_c[41],sr.faj18,
#            COLUMN g_c[44],cl_numfor(sr.faj14,44,g_azi04),   #MOD-640529
#            COLUMN g_c[42],sr.faj26,
#            COLUMN g_c[43],l_sts
 
#   ON LAST ROW
#      PRINT g_dash[1,g_len]
#      LET l_last_sw = 'y'
#      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
#   PAGE TRAILER
#      IF l_last_sw = 'n'
#         THEN PRINT g_dash[1,g_len]
#              PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#         ELSE SKIP 2 LINE
#      END IF
#END REPORT
#No.FUN-7B0138--MARK END


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END
