# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axrr635.4gl
# Descriptions...: 催收款明細表(axrr635) FOR KB SALES
# Date & Author..: 99/01/08 by Billy
# Modify.........: No.B064 04/05/14 By kitty DELETE r635_tot改地方
# Modify.........: No.FUN-4C0100 05/01/01 By Smapmin 報表轉XML格式
# Modify.........: No.TQC-5C0086 05/12/20 By Carrier AR月底重評修改 
# Modify.........: No.TQC-610059 06/06/05 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/27 By Xumin l_time轉g_time
# Modify.........: No.MOD-6A0101 06/12/05 By Smapmin 只修改ora檔
# Modify.........: No.TQC-6C0147 06/12/26 By Rayven 報表格式調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-C40001 12/04/13 By SunLM 增加開窗功能

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                                 # Print condition RECORD
              wc       LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)  # Where condition
              s        LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)  # 排序方式
              more     LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)  # Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt         LIKE type_file.num10          #No.FUN-680123 INTEGER
DEFINE   g_i           LIKE type_file.num5           #count/index for any purpose #No.FUN-680123 SMALLINT
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
 
   #-----TQC-610059---------
   LET g_pdate=ARG_VAL(1)
   LET g_towhom=ARG_VAL(2)
   LET g_rlang=ARG_VAL(3)
   LET g_bgjob=ARG_VAL(4)
   LET g_prtway=ARG_VAL(5)
   LET g_copies=ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
   LET tm.s = ARG_VAL(8)
   #-----END TQC-610059-----
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(9)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
   #No.FUN-570264 ---end---  #No.FUN-680123 
   CREATE TEMP TABLE r635_tmp
   (tmp01 LIKE oma_file.oma23,
    tmp02 LIKE type_file.num20_6,
    tmp03 LIKE type_file.num20_6)
   create unique index r635_tmp_01 on r635_tmp(tmp01);
   CREATE TEMP TABLE r635_tot
   (tot01 LIKE oma_file.oma23,
    tot02 LIKE type_file.num20_6,
    tot03 LIKE type_file.num20_6)
            #No.FUN-680123 end
   create unique index r635_tot_01 on r635_tot(tot01);
   IF cl_null(tm.wc) THEN
      CALL axrr635_tm(0,0)                # Input print condition
   ELSE
      CALL axrr635()                      # Read data and create out-file
   END IF
   DROP TABLE r635_tmp
   DROP TABLE r635_tot
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION axrr635_tm(p_row,p_col)
DEFINE lc_qbe_sn         LIKE gbm_file.gbm01           #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_cmd          LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 15 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 5 LET p_col = 15
   ELSE LET p_row = 4 LET p_col = 15
   END IF
   OPEN WINDOW axrr635_w AT p_row,p_col
        WITH FORM "axr/42f/axrr635"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                # Default condition
   LET tm.more = 'N'
   LET tm.s    = '2'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON oma03, oma15, oma14, omb31,oma02
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
 
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
      #No.FUN-C40001  --Begin
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oma15)#部門
                 CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem1"   #No.MOD-530272
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma15
                 NEXT FIELD oma15
            WHEN INFIELD(oma03)#賬款客戶編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma03
                 NEXT FIELD oma03
            WHEN INFIELD(oma14)#人員編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oma14
                 NEXT FIELD oma14
            WHEN INFIELD(omb31)#出貨/銷退單號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_omb31"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO omb31
                 NEXT FIELD omb31
            END CASE
      #No.FUN-C40001  --End   
  END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axrr635_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF tm.wc=" 1=1" THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
   INPUT BY NAME tm.s,tm.more
                WITHOUT DEFAULTS
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD s
         IF tm.s NOT MATCHES '[12]' THEN
            NEXT FIELD s
         END IF
 
      AFTER FIELD more
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
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
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
      LET INT_FLAG = 0 CLOSE WINDOW axrr635_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr635'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr635','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'" ,
                         " '",tm.s CLIPPED,"'"  ,   #TQC-610059
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'"            #No.FUN-570264
         CALL cl_cmdat('axrr635',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW axrr635_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr635()
   ERROR ""
END WHILE
   CLOSE WINDOW axrr635_w
END FUNCTION
 
FUNCTION axrr635()
   DEFINE l_name    LIKE type_file.chr20,            #No.FUN-680123 VARCHAR(20)  # External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0095
          l_sql     LIKE type_file.chr1000,          #No.FUN-680123 VARCHAR(1000)
          l_za05    LIKE za_file.za05,               #No.FUN-680123 VARCHAR(40) 
          l_oag02   LIKE oag_file.oag02,
          l_ooa02   LIKE ooa_file.ooa02,
          sr        RECORD
                order1    LIKE  oma_file.oma03,        #No.FUN-680123 VARCHAR(10)
                order2    LIKE  oma_file.oma03,        #No.FUN-680123 VARCHAR(10)
                oma01     LIKE  oma_file.oma01 ,       #帳款編號
                oma02     LIKE  oma_file.oma02 ,       #立帳日
                oma03     LIKE  oma_file.oma03 ,       #帳款客戶
                oma032    LIKE  oma_file.oma032 ,      #帳款客戶簡稱
                oma11     LIKE  oma_file.oma11 ,       #應收款日
                oma14     LIKE  oma_file.oma14,        #業務人員
                oma23     LIKE  oma_file.oma23 ,       #幣別
                oma32     LIKE  oma_file.oma32 ,       #收款條件
                omb03     LIKE  omb_file.omb03 ,       #項次
                omb31     LIKE  omb_file.omb31 ,       #出貨單號
                omb04     LIKE  omb_file.omb04 ,       #料號
                omb14t    LIKE  omb_file.omb14t,       #原幣金額
                omb16t    LIKE  omb_file.omb16t,       #本幣金額
                omb32     LIKE  omb_file.omb32 ,       #收款條件
                omb34     LIKE  omb_file.omb34 ,       #原幣已沖金額
                omb35     LIKE  omb_file.omb35 ,       #本幣已沖金額
                omb37     LIKE  omb_file.omb37,        #add No.A057 本幣未沖金額
                oag04     LIKE  oag_file.oag04 ,       #應收款天數
                sale_day  LIKE  oma_file.oma02,        #已出天數 #No.FUN-680123 DEC(16,0)
                over_day  LIKE  oma_file.oma11,        #超出天數 #No.FUN-680123 DEC(16,0)
                term      LIKE  oag_file.oag02         #No.FUN-680123 VARCHAR(15)
                END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     #====>資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN#只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND omauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND omagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND omagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('omauser', 'omagrup')
     #End:FUN-980030
 
     #No.TQC-5C0086  --Begin                                                                                                        
     IF g_ooz.ooz07 = 'N' THEN
        LET l_sql = " SELECT '','',oma01,oma02,oma03,oma032,oma11,oma14,oma23,",
                    " oma32,omb03, omb31, omb04, omb14t, omb16t,omb32,omb34,",
                    " omb35,omb37,oag04 , '','','' " ,   #NO:A057
                    "  FROM oma_file, omb_file, oag_file ",
                    " WHERE oma00 MATCHES '1*' " ,
                    "   AND oma01 = omb01 AND oma32 = oag01 ",
                    "   AND omaconf = 'Y' AND omavoid = 'N' ",
                    "   AND ", tm.wc CLIPPED,
                    "   AND omb16t <> omb35 "   #No:A057
                  # "   AND omb37 > 0       "
     ELSE                                                                                                                           
        LET l_sql = " SELECT '','',oma01,oma02,oma03,oma032,oma11,oma14,oma23,",                                                    
                    " oma32,omb03, omb31, omb04, omb14t, omb16t,omb32,omb34,",                                                      
                    " omb35,omb37,oag04 , '','','' " ,                                                                              
                    "  FROM oma_file, omb_file, oag_file ",                                                                         
                    " WHERE oma00 MATCHES '1*' " ,                                                                                  
                    "   AND oma01 = omb01 AND oma32 = oag01 ",                                                                      
                    "   AND omaconf = 'Y' AND omavoid = 'N' ",                                                                      
                    "   AND ", tm.wc CLIPPED,                                                                                       
                    "   AND omb37 > 0       "                                                                                       
     END IF                                                                                                                         
     #No.TQC-5C0086  --End 
 
 
     PREPARE axrr635_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
        EXIT PROGRAM
     END IF
     DECLARE axrr635_curs1 CURSOR FOR axrr635_prepare1
 
     CALL cl_outnam('axrr635') RETURNING l_name
     START REPORT axrr635_rep TO l_name
 
     LET g_pageno = 0
     FOREACH axrr635_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
 
#      IF cl_null(sr.oga02) THEN LET sr.oga02 = sr.oma02 END IF
       LET sr.sale_day = g_pdate - sr.oma02
       LET sr.over_day = g_pdate - sr.oma11
       IF cl_null(sr.sale_day) or sr.sale_day < 0 THEN LET sr.sale_day=0 END IF
       IF cl_null(sr.over_day) or sr.over_day < 0 THEN LET sr.over_day=0 END IF
 
       SELECT oag02 INTO l_oag02 FROM oag_file WHERE oag01 = sr.oma32
       IF SQLCA.sqlcode OR cl_null(l_oag02) THEN LET l_oag02 = sr.oma32 END IF
       LET sr.term = l_oag02
 
       IF tm.s = '1' THEN
          LET sr.order1 = sr.oma03
          LET sr.order2 = sr.oma14
       ELSE
          LET sr.order1 = sr.oma14
          LET sr.order2 = sr.oma03
       END IF
 
       OUTPUT TO REPORT axrr635_rep(sr.*)
     END FOREACH
 
     FINISH REPORT axrr635_rep
 
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #020103==>
     #DELETE FROM r635_tot   #No:B064 改在AFTER GROUP sr.order2刪
      DELETE FROM r635_tmp
END FUNCTION
 
REPORT axrr635_rep(sr)
   DEFINE l_last_sw       LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
          l_flag          LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
          g_head1         STRING,
          l_ima02         LIKE ima_file.ima02,
          l_ima021        LIKE ima_file.ima021,
          sr        RECORD
                order1    LIKE  occ_file.occ01,       #No.FUN-680123 VARCHAR(10)
                order2    LIKE  oma_file.oma03,       #No.FUN-680123 VARCHAR(10)
                oma01     LIKE  oma_file.oma01,
                oma02     LIKE  oma_file.oma02,
                oma03     LIKE  oma_file.oma03,
                oma032    LIKE  oma_file.oma032,
                oma11     LIKE  oma_file.oma11,
                oma14     LIKE  oma_file.oma14,
                oma23     LIKE  oma_file.oma23,
                oma32     LIKE  oma_file.oma32,
                omb03     LIKE  omb_file.omb03,
                omb31     LIKE  omb_file.omb31,
                omb04     LIKE  omb_file.omb04,
                omb14t    LIKE  omb_file.omb14t,
                omb16t    LIKE  omb_file.omb16t,
                omb32     LIKE  omb_file.omb32,
                omb34     LIKE  omb_file.omb34,
                omb35     LIKE  omb_file.omb35,
                omb37     LIKE  omb_file.omb37,        #add No.A057
                oag04     LIKE  oag_file.oag04,
                sale_day  LIKE  oma_file.oma01,        #No.FUN-680123 DEC(16,0)
                over_day  LIKE  oma_file.oma11,        #No.FUN-680123 DEC(16,0)
                term      LIKE  oag_file.oag02         #No.FUN-680123 VARCHAR(15)
                END RECORD,
          st    RECORD
                tmp01     LIKE  oma_file.oma23,        #No.FUN-680123 VARCHAR(04)
                tmp02     LIKE type_file.num20_6,      #No.FUN-680123 DEC(20,6)
                tmp03     LIKE type_file.num20_6       #No.FUN-680123 DEC(20,6)
                END RECORD,
                 l_n            LIKE type_file.num5,   #No.FUN-680123 SMALLINT
                 l_amt1         LIKE omb_file.omb16t,  ###應收原幣金額加總
                 l_amt2         LIKE omb_file.omb35,   ###應收台幣金額加總
                 l_count1       LIKE type_file.num5,   #No.FUN-680123 SMALLINT
                 l_ave1         LIKE type_file.num5,   #No.FUN-680123 SMALLINT
                 l_gen02        LIKE gen_file.gen02
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
 
  ORDER BY sr.order1,sr.order2,sr.oma02
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0147 mark
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED, pageno_total
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]  #No.TQC-6C0147
      IF tm.s = '1' THEN
         SELECT occ18 into l_gen02
         FROM occ_file
         WHERE occ01=sr.order1
         PRINT g_x[13] CLIPPED,sr.order1,'  ',l_gen02
      ELSE
         SELECT gen02 into l_gen02
         FROM gen_file
         WHERE GEN01=sr.order1
         PRINT g_x[14] CLIPPED,sr.order1,'  ',l_gen02
      END IF
      PRINT g_dash[1,g_len]
      PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38],
            g_x[39],g_x[40],g_x[41],g_x[42],g_x[43],g_x[44],g_x[45]
      PRINT g_dash1
      LET l_last_sw='n'
      LET l_flag='Y'
 
   ON EVERY ROW
      ##-小計與總計的處理
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位
         FROM azi_file
        WHERE azi01=sr.oma23
      SELECT COUNT(*) INTO l_n FROM r635_tmp WHERE tmp01=sr.oma23
      SELECT COUNT(*) INTO g_cnt FROM r635_tot WHERE tot01=sr.oma23
      IF NOT cl_null(sr.oma23) THEN
         LET l_amt1=sr.omb14t-sr.omb34
         LET l_amt2=sr.omb37                          #No.A057
         IF l_n > 0 THEN
            UPDATE r635_tmp SET tmp02=tmp02+l_amt1,tmp03=tmp03+l_amt2
             WHERE tmp01=sr.oma23
         ELSE
           INSERT INTO r635_tmp
           VALUES(sr.oma23,l_amt1,l_amt2)
         END IF
         IF g_cnt > 0 THEN
            UPDATE r635_tot SET tot02=tot02+l_amt1,tot03=tot03+l_amt2
             WHERE tot01=sr.oma23
         ELSE
           INSERT INTO r635_tot
           VALUES(sr.oma23,l_amt1,l_amt2)
         END IF
      END IF
      ##---
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = sr.omb04
      PRINT  COLUMN g_c[33],sr.omb31  CLIPPED, '-', sr.omb32 USING'##',
             COLUMN g_c[34],sr.oma02,
             COLUMN g_c[35],sr.oma11,
             COLUMN g_c[36],sr.sale_day USING '#######&' ,
             COLUMN g_c[37],sr.over_day USING '#######&' ,
             COLUMN g_c[38],sr.omb04 CLIPPED,
             COLUMN g_c[39],l_ima02,
             COLUMN g_c[40],l_ima021,
             COLUMN g_c[41],sr.oma23[1,3] CLIPPED,
             COLUMN g_c[42],cl_numfor(sr.omb14t-sr.omb34,42,t_azi04), #應收原幣
             COLUMN g_c[43],cl_numfor(sr.omb37,43,g_azi04), #應收本幣 #No.A057
             COLUMN g_c[44],sr.oag04 USING '###&' ,
             COLUMN g_c[45],sr.term CLIPPED
 
   BEFORE GROUP OF sr.order2
      PRINT COLUMN g_c[31],sr.oma03,
            COLUMN g_c[32],sr.oma032
 
   BEFORE GROUP OF sr.order1
      SKIP TO TOP OF PAGE
 
   AFTER GROUP OF sr.order2
    # LET l_amt1 = GROUP SUM(sr.omb14t-sr.omb34)
    # LET l_amt2 = GROUP SUM(sr.omb37)                   #No.A057
    # PRINT COLUMN g_c[40], g_x[12] CLIPPED ,
    #       COLUMN g_c[42], cl_numfor(l_amt1,42,t_azi04),  #應收原幣
    #       COLUMN g_c[43],cl_numfor(l_amt2,43,g_azi04)   #應收台幣
      #依幣別小計
      DECLARE r635_tot_cs CURSOR FOR
       SELECT * FROM r635_tot
      FOREACH r635_tot_cs INTO st.*
        SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位
         FROM azi_file
        WHERE azi01=st.tmp01
        PRINT COLUMN g_c[40],g_x[12] CLIPPED,
              COLUMN g_c[41], st.tmp01,
              COLUMN g_c[42],cl_numfor(st.tmp02,42,t_azi05),  #應收原幣
              COLUMN g_c[43],cl_numfor(st.tmp03,43,g_azi05)   #應收台幣
      END FOREACH
      PRINT ''
      DELETE FROM r635_tot    #No:B064
 
   ON LAST ROW
    # LET l_ave1 = AVERAGE(sr.day)  WHERE sr.day > 0
    # LET l_amt1 = SUM(sr.omb14t-sr.omb34)
    # LET l_amt2 = SUM(sr.omb37)                          #No.A057
      #依幣別總計
      DECLARE r635_tmp_cs CURSOR FOR
       SELECT * FROM r635_tmp
      FOREACH r635_tmp_cs INTO st.*
         SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05  #抓幣別取位
         FROM azi_file
         WHERE azi01=st.tmp01
         PRINT COLUMN g_c[40],g_x[15] CLIPPED,
               COLUMN g_c[41],st.tmp01,
               COLUMN g_c[42], cl_numfor(st.tmp02,42,t_azi05),  #應收原幣
               COLUMN g_c[43], cl_numfor(st.tmp03,43,g_azi05)   #應收台幣
      END FOREACH
    # PRINT COLUMN g_c[40], g_x[15] CLIPPED ,
    #       COLUMN g_c[42], cl_numfor(l_amt1,42,t_azi04),  #應收原幣
    #       COLUMN g_c[43], cl_numfor(l_amt2,43,g_azi04)   #應收台幣
      PRINT g_dash[1,g_len]
      LET l_last_sw='y'
#     PRINT g_x[16],COLUMN g_c[45],g_x[9] CLIPPED    #No.TQC-6C0147 mark
      PRINT g_x[16],COLUMN (g_len-9),g_x[9] CLIPPED  #No.TQC-6C0147
 
   PAGE TRAILER
      IF l_last_sw='n' THEN
         PRINT g_dash[1,g_len]
#        PRINT g_x[16],COLUMN g_c[45],g_x[8] CLIPPED    #No.TQC-6C0147 mark
         PRINT g_x[16],COLUMN (g_len-9),g_x[8] CLIPPED  #No.TQC-6C0147
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
#MOD-6A0101 修改ora檔
