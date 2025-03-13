# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: anmr930.4gl
# Descriptions...: 集團資金調撥還本(息)維護
# Date & Author..: No.FUN-640144 06/04/19 By Nicola
# Modify.........: No.FUN-670066 06/07/18 By douzh voucher型報表轉template1
# Modify.........: No.FUN-680107 06/09/07 By ice 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-690090 06/11/16 By Rayven 增加內部帳戶部分,選資料應該跨庫去選
# Modify.........: No.TQC-6B0114 06/11/28 By Rayven 打印內容編號和后面帶出的欄位沒有用空格隔開
# Modify.........: No.FUN-710085 07/02/02 By wujie 使用水晶報表打印
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.FUN-740049 07/04/12 By arman 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/19 By arman 會計科目加帳套
# Modify.........: No.TQC-740137 07/04/19 By Carrier s_get_bookno1的db參數去掉分隔符
# Modify.........: No.TQC-740224 07/04/24 By Carrier s_get_bookno1的db參數加上分隔符
# Modify.........: No.TQC-760017 07/06/04 By Sarah anmr930/anmr940共用程式,940出表有問題
# Modify.........: No.TQC-960163 09/06/16 By sabrina EXECUTE寫法有誤
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.TQC-C10034 12/01/19 By yuhuabao GP 5.3 CR報表列印TIPTOP與EasyFlow簽核圖片
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm  RECORD
               wc      STRING,
               more    LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
           END RECORD
DEFINE g_cnt   LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_i     LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_nnw00 LIKE nnw_file.nnw00
DEFINE g_msg   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE l_table       STRING                   #FUN-710085 add 
DEFINE g_sql         STRING                   #FUN-710085 add
DEFINE g_str         STRING                   #FUN-710085 add
DEFINE g_bookno1     LIKE   aza_file.aza81    #FUN-740049
DEFINE g_bookno2     LIKE   aza_file.aza82    #FUN-740049
DEFINE g_flag        LIKE   type_file.chr1    #FUN-740049
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_nnw00 = ARG_VAL(1)
   LET g_pdate = ARG_VAL(2)
   LET g_towhom = ARG_VAL(3)
   LET g_rlang = ARG_VAL(4)
   LET g_bgjob = ARG_VAL(5)
   LET g_prtway = ARG_VAL(6)
   LET g_copies = ARG_VAL(7)
   LET tm.wc = ARG_VAL(8)
   LET tm.more = ARG_VAL(9)
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
 
   CASE
      WHEN g_nnw00 = '1'
         LET g_prog = 'anmr930'
      WHEN g_nnw00 = '2'
         LET g_prog = 'anmr940'
   END CASE
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#No.FUN-710085--begin 
   LET g_sql = "nnw00.nnw_file.nnw00,", 
               "nnw01.nnw_file.nnw01,",     
               "nnw02.nnw_file.nnw02,",     
               "nnw03.nnw_file.nnw03,",     
               "nnw04.nnw_file.nnw04,",     
               "nnw05.nnw_file.nnw05,",     
               "nnw06.nnw_file.nnw06,",     
               "nnw07.nnw_file.nnw07,",     
               "nnw08.nnw_file.nnw08,",     
               "nnw09.nnw_file.nnw09,",     
               "nnw10.nnw_file.nnw10,",     
               "nnw11.nnw_file.nnw11,",     
               "nnw12.nnw_file.nnw12,",
               "nnw13.nnw_file.nnw13,",     
               "nnw14.nnw_file.nnw14,",     
               "nnw15.nnw_file.nnw15,",     
               "nnw16.nnw_file.nnw16,",     
               "nnw17.nnw_file.nnw17,",     
               "nnw18.nnw_file.nnw18,",     
               "nnw19.nnw_file.nnw19,",
               "nnw20.nnw_file.nnw20,",     
               "nnw21.nnw_file.nnw21,",     
               "nnw22.nnw_file.nnw22,",     
               "nnw23.nnw_file.nnw23,",     
               "nnw24.nnw_file.nnw24,",     
               "nnw25.nnw_file.nnw25,",     
               "nnw26.nnw_file.nnw26,",     
               "nnw27.nnw_file.nnw27,",
               "nnw28.nnw_file.nnw28,",     
               "nnw29.nnw_file.nnw29,",     
               "nnw30.nnw_file.nnw30,",     
               "nnwconf.nnw_file.nnwconf,", 
               "nnwacti.nnw_file.nnwacti,", 
               "nnwuser.nnw_file.nnwuser,", 
               "nnwgrup.nnw_file.nnwgrup,", 
               "nnwmodu.nnw_file.nnwmodu,", 
               "nnwdate.nnw_file.nnwdate,", 
               "nnw121.nnw_file.nnw121,",      #No.TQC-740137
               "nnw191.nnw_file.nnw191,",      #No.TQC-740137
               "nnw271.nnw_file.nnw271,",      #No.TQC-740137
               "nnw31.nnw_file.nnw31,",     
               "nnw32.nnw_file.nnw32,",     
               "nnx01.nnx_file.nnx01,",     
               "nnx02.nnx_file.nnx02,",     
               "nnx03.nnx_file.nnx03,",     
               "nnx04.nnx_file.nnx04,",     
               "nnx05.nnx_file.nnx05,",     
               "nnx06.nnx_file.nnx06,",     
               "nnx07.nnx_file.nnx07,",     
               "nnx08.nnx_file.nnx08,",     
               "nnx09.nnx_file.nnx09,",     
               "nnx10.nnx_file.nnx10,",     
               "nnx11.nnx_file.nnx11,",     
               "nnx12.nnx_file.nnx12,",     
               "nnx13.nnx_file.nnx13,",     
               "nnx14.nnx_file.nnx14,",     
               "nnx15.nnx_file.nnx15,",     
               "nnx16.nnx_file.nnx16,",     
               "nnx17.nnx_file.nnx17,",     
               "nnx18.nnx_file.nnx18,",     
               "nnx19.nnx_file.nnx19,",     
               "nnx20.nnx_file.nnx20,",     
               "nnx21.nnx_file.nnx21,",     
               "nnx201.nnx_file.nnx201,",    
               "nnx211.nnx_file.nnx211,",    
               "nmydesc.nmy_file.nmydesc,",  
               "gem02.gem_file.gem02,",      
               "nml02.nml_file.nml02,",      
               "azp02_1.azp_file.azp02,",    
               "azp02_2.azp_file.azp02,",    
               "nma02_1.nma_file.nma02,",    
               "nmc02_1.nmc_file.nmc02,",    
               "aag02_1.aag_file.aag02,",    
               "azi04_1.azi_file.azi04,",    
               "azi07_1.azi_file.azi07,",    
               "nma02_2.nma_file.nma02,",    
               "nmc02_2.nmc_file.nmc02,",    
               "aag02_2.aag_file.aag02,",    
               "azi04_2.azi_file.azi04,",    
               "azi07_2.azi_file.azi07,",    
               "nma02_3.nma_file.nma02,",    
               "nmc02_3.nmc_file.nmc02,",    
               "aag02_3.aag_file.aag02,",    
               "azi04_3.azi_file.azi04,",    
               "azi07_3.azi_file.azi07,",    
               "azi04_4.azi_file.azi04,",    
               "azi07_4.azi_file.azi07,",    
               "nma02_4.nma_file.nma02,",    
               "nma02_5.nma_file.nma02,",     #No.TQC-C10034 add , ,      
               "sign_type.type_file.chr1,",   #簽核方式                   #No.TQC-C10034 add
               "sign_img.type_file.blob,",    #簽核圖檔                   #No.TQC-C10034 add
               "sign_show.type_file.chr1,",   #是否顯示簽核資料(Y/N)      #No.TQC-C10034 add
               "sign_str.type_file.chr1000"   #簽核字串                   #No.TQC-C10034 add
                                               
   LET l_table = cl_prt_temptable('anmr930',g_sql) CLIPPED 
   IF l_table = -1 THEN EXIT PROGRAM END IF    
  #LET g_sql = "INSERT INTO ds_report:",l_table CLIPPED,               #TQC-960163 mark 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,     #TQC-960163 add
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ,?,?,?,?)" #No.TQC-C10034 add 4?  
   PREPARE insert_prep FROM g_sql              
   IF STATUS THEN                              
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM    
   END IF                           
#No.FUN-710085--end 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN 
      CALL anmr930_tm()
   ELSE
      CALL anmr930()
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION anmr930_tm()
   DEFINE lc_qbe_sn     LIKE gbm_file.gbm01
   DEFINE p_row,p_col   LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_cmd         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW anmr930_w AT p_row,p_col
     WITH FORM "anm/42f/anmr930"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CASE WHEN g_nnw00 = '1'  #還本
      CALL cl_getmsg('anm-920',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("nnw01",g_msg CLIPPED)
       WHEN g_nnw00 = '2'
      CALL cl_getmsg('anm-922',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("nnw01",g_msg CLIPPED)
   END CASE
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
      CONSTRUCT BY NAME tm.wc ON nnw01,nnw02
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
        
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
        
         ON ACTION about
            CALL cl_about()
        
         ON ACTION help
            CALL cl_show_help()
        
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('nnwuser', 'nnwgrup') #FUN-980030
 
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr930_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE 
      END IF
 
      INPUT BY NAME tm.more WITHOUT DEFAULTS
 
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
 
         AFTER FIELD more
            IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more) THEN
               NEXT FIELD more
            END IF
            IF tm.more = 'Y' THEN
               CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies)
                    RETURNING g_pdate,g_towhom,g_rlang,
                              g_bgjob,g_time,g_prtway,g_copies
            END IF
 
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
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW anmr910_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file
          WHERE zz01='anmr930'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('anmr930','9031',1)
         ELSE
            LET tm.wc = cl_replace_str(tm.wc,"'","\"")
            LET l_cmd = l_cmd CLIPPED,
                        " '",g_nnw00 CLIPPED,"'",
                        " '",g_pdate CLIPPED,"'",
                        " '",g_towhom CLIPPED,"'",
                        #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                        " '",g_bgjob CLIPPED,"'",
                        " '",g_prtway CLIPPED,"'",
                        " '",g_copies CLIPPED,"'",
                        " '",tm.wc CLIPPED,"'",
                        " '",tm.more CLIPPED,"'",
                        " '",g_rep_user CLIPPED,"'",
                        " '",g_rep_clas CLIPPED,"'",
                        " '",g_template CLIPPED,"'"
            CALL cl_cmdat('anmr930',g_time,l_cmd)
         END IF
 
         CLOSE WINDOW anmr930_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      CALL cl_wait()
      CALL anmr930()
 
      ERROR ""
   END WHILE
 
   CLOSE WINDOW anmr930_w
 
END FUNCTION
 
FUNCTION anmr930()
   DEFINE l_name      LIKE type_file.chr20,   #No.FUN-680107 VARCHAR(20)
#       l_time          LIKE type_file.chr8          #No.FUN-6A0082
          l_buf       LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(6)
          l_sql       STRING,
          sr          RECORD
                         nnw      RECORD LIKE nnw_file.*,
                         nnx      RECORD LIKE nnx_file.*,
                         nmydesc  LIKE nmy_file.nmydesc,
                         gem02    LIKE gem_file.gem02,
                         nml02    LIKE nml_file.nml02,
                         azp02_1  LIKE azp_file.azp02,
                         azp02_2  LIKE azp_file.azp02,
                         nma02_1  LIKE nma_file.nma02,
                         nmc02_1  LIKE nmc_file.nmc02,
                         aag02_1  LIKE aag_file.aag02,
                         azi04_1  LIKE azi_file.azi04,
                         azi07_1  LIKE azi_file.azi07,
                         nma02_2  LIKE nma_file.nma02,
                         nmc02_2  LIKE nmc_file.nmc02,
                         aag02_2  LIKE aag_file.aag02,
                         azi04_2  LIKE azi_file.azi04,
                         azi07_2  LIKE azi_file.azi07,
                         nma02_3  LIKE nma_file.nma02,
                         nmc02_3  LIKE nmc_file.nmc02,
                         aag02_3  LIKE aag_file.aag02,
                         azi04_3  LIKE azi_file.azi04,
                         azi07_3  LIKE azi_file.azi07,
                         azi04_4  LIKE azi_file.azi04,
                         azi07_4  LIKE azi_file.azi07,
                         nma02_4  LIKE nma_file.nma02,  #No.FUN-690090
                         nma02_5  LIKE nma_file.nma02   #No.FUN-690090
                      END RECORD
   DEFINE l_dbs1      LIKE type_file.chr21              #No.FUN-690090
   DEFINE l_plant1    LIKE type_file.chr10              #No.FUN-980020
   DEFINE l_dbs2      LIKE type_file.chr21              #No.FUN-690090
   DEFINE l_prog      LIKE type_file.chr10              #TQC-740017 add
   DEFINE l_img_blob     LIKE type_file.blob                                         #No.TQC-C10034 add
   LOCATE l_img_blob IN MEMORY   #blob初始化   #Genero Version 2.21.02之後要先初始化 #No.TQC-C10034 add
                                             
#No.FUN-710085--begin                       
     CALL cl_del_data(l_table)             
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog 
#No.FUN-710085--end 
 
# No.FUN-670066--begin
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
#  SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog 
#  FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#  FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '-' END FOR
# No.FUN-670066--end
 
  LET l_sql = "SELECT nnw_file.*,nnx_file.*,'','','','','','','',",
               "       '','','','','','','','','','','',''",
               "  FROM nnw_file,nnx_file",
               " WHERE ",tm.wc CLIPPED,
               "   AND nnw01 = nnx01",
               "   AND nnw00 = '",g_nnw00,"'",
               " ORDER BY nnw01"
 
   PREPARE anmr930_prepare FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
 
   DECLARE anmr930_curs CURSOR FOR anmr930_prepare
 
   LET l_prog = g_prog      #TQC-760017 add
   LET g_prog = 'anmr930'   #TQC-760017 add
 
#No.FUN-710085--begin
#   CALL cl_outnam(g_prog) RETURNING l_name
#   START REPORT anmr930_rep TO l_name
#   LET g_pageno = 0
#   #No.FUN-670066 --begin
#   IF g_nnw00='2' THEN
#      LET g_zaa[38].zaa06='Y'
#      LET g_zaa[39].zaa06='Y'
#      LET g_zaa[40].zaa06='Y'
#      LET g_zaa[41].zaa06='Y'
#      LET g_zaa[42].zaa06='Y'
#      LET g_zaa[43].zaa06='N'
#      LET g_zaa[44].zaa06='N'
#      LET g_zaa[45].zaa06='N'
#      LET g_zaa[46].zaa06='N'
#      LET g_zaa[47].zaa06='N'
#      LET g_zaa[48].zaa06='N'
#   ELSE
#       LET g_zaa[38].zaa06='N'
#       LET g_zaa[39].zaa06='N'
#       LET g_zaa[40].zaa06='N'
#       LET g_zaa[41].zaa06='N'
#       LET g_zaa[42].zaa06='N'
#       LET g_zaa[43].zaa06='Y'
#       LET g_zaa[44].zaa06='Y'
#       LET g_zaa[45].zaa06='Y'
#       LET g_zaa[46].zaa06='Y'
#       LET g_zaa[47].zaa06='Y'
#       LET g_zaa[48].zaa06='Y'
#   END IF    
#   CALL cl_prt_pos_len()
#No.FUN-710085--end
   # No.FUN-670066--end
   FOREACH anmr930_curs INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
 #        EXIT FOREACH
      END IF
 
      #No.FUN-690090 --start--                                                                                                      
      LET l_plant1 = sr.nnw.nnw05                      #FUN-980020
      LET g_plant_new = sr.nnw.nnw05
      CALL s_getdbs()
      LET l_dbs1 = g_dbs_new
#NO.FUN-740049     ---Begin
#      CALL s_get_bookno1(YEAR(sr.nnw.nnw02),l_dbs1)   RETURNING g_flag,g_bookno1,g_bookno2  #TQC-740093  #No.TQC-740224 #FUN-980020 mark
       CALL s_get_bookno1(YEAR(sr.nnw.nnw02),l_plant1)   RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
#NO.FUN-740049    ---END
      LET g_plant_new = sr.nnw.nnw20
      CALL s_getdbs()
      LET l_dbs2 = g_dbs_new
      #No.FUN-690090 --end--
 
      LET l_buf = s_get_doc_no(sr.nnw.nnw01)
      SELECT nmydesc INTO sr.nmydesc FROM nmy_file
       WHERE nmyslip = l_buf
 
      SELECT gem02 INTO sr.gem02 FROM gem_file
       WHERE gem01 = sr.nnw.nnw03
 
      SELECT nml02 INTO sr.nml02 FROM nml_file
       WHERE nml01 = sr.nnw.nnw04
       
      SELECT azp02 INTO sr.azp02_1  FROM azp_file
       WHERE azp01 = sr.nnw.nnw05
 
      SELECT azp02 INTO sr.azp02_2  FROM azp_file
       WHERE azp01 = sr.nnw.nnw20
 
#No.FUN-690090 --start-- mark
#     SELECT nma02 INTO sr.nma02_1  FROM nma_file
#      WHERE nma01 = sr.nnw.nnw06
 
#     SELECT nmc02 INTO sr.nmc02_1  FROM nmc_file
#      WHERE nmc01 = sr.nnw.nnw07
 
#     SELECT aag02 INTO sr.aag02_1  FROM aag_file
#      WHERE aag01 = sr.nnw.nnw12
 
#     SELECT azi04,azi07 INTO sr.azi04_1,sr.azi07_1  FROM azi_file
#      WHERE azi01 = sr.nnw.nnw08
 
#     SELECT nma02 INTO sr.nma02_2  FROM nma_file
#      WHERE nma01 = sr.nnw.nnw21
 
#     SELECT nmc02 INTO sr.nmc02_2  FROM nmc_file
#      WHERE nmc01 = sr.nnw.nnw22
 
#     SELECT aag02 INTO sr.aag02_2  FROM aag_file
#      WHERE aag01 = sr.nnw.nnw27
 
#     SELECT azi04,azi07 INTO sr.azi04_2,sr.azi07_2  FROM azi_file
#      WHERE azi01 = sr.nnw.nnw23
 
#     SELECT nma02 INTO sr.nma02_3  FROM nma_file
#      WHERE nma01 = sr.nnw.nnw13
 
#     SELECT nmc02 INTO sr.nmc02_3  FROM nmc_file
#      WHERE nmc01 = sr.nnw.nnw14
 
#     SELECT aag02 INTO sr.aag02_3  FROM aag_file
#      WHERE aag01 = sr.nnw.nnw19
 
#     SELECT azi04,azi07 INTO sr.azi04_3,sr.azi07_3  FROM azi_file
#      WHERE azi01 = sr.nnw.nnw15
#No.FUN-690090 --end--
 
      SELECT azi04,azi07 INTO sr.azi04_4,sr.azi07_4  FROM azi_file
       WHERE azi01 = sr.nnx.nnx05
 
      #No.FUN-690090 --start--
      SELECT aag02 INTO sr.aag02_1
        FROM aag_file
       WHERE aag01 = sr.nnx.nnx20
          AND aag00 = g_bookno1      #NO.FUN-740049
      SELECT aag02 INTO sr.aag02_2
        FROM aag_file
       WHERE aag01 = sr.nnx.nnx21
          AND aag00 = g_bookno2      #NO.FUN-740049
      #LET l_sql = "SELECT nma02 FROM ",l_dbs1,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnw.nnw05,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnw.nnw06,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p1 FROM l_sql
      DECLARE nma02_c1 CURSOR FOR nma02_p1
      OPEN nma02_c1
      FETCH nma02_c1 INTO sr.nma02_1
 
      #LET l_sql = "SELECT nmc02 FROM ",l_dbs1,"nmc_file",
      LET l_sql = "SELECT nmc02 FROM ",cl_get_target_table(sr.nnw.nnw05,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",sr.nnw.nnw07,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE nmc02_p1 FROM l_sql
      DECLARE nmc02_c1 CURSOR FOR nmc02_p1
      OPEN nmc02_c1
      FETCH nmc02_c1 INTO sr.nmc02_1
 
      #LET l_sql = "SELECT azi04,azi07 FROM ",l_dbs1,"azi_file",
      LET l_sql = "SELECT azi04,azi07 FROM ",cl_get_target_table(sr.nnw.nnw05,'azi_file'), #FUN-A50102
                  " WHERE azi01 = '",sr.nnw.nnw08,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE azi04_p1 FROM l_sql
      DECLARE azi04_c1 CURSOR FOR azi04_p1
      OPEN azi04_c1
      FETCH azi04_c1 INTO sr.azi04_1,sr.azi07_1
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs1,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnw.nnw05,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnw.nnw31,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p4 FROM l_sql
      DECLARE nma02_c4 CURSOR FOR nma02_p4
      OPEN nma02_c4
      FETCH nma02_c4 INTO sr.nma02_4
      
      #LET l_sql = "SELECT nma02 FROM ",l_dbs2,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnw.nnw20,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnw.nnw21,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw20) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p2 FROM l_sql
      DECLARE nma02_c2 CURSOR FOR nma02_p2
      OPEN nma02_c2
      FETCH nma02_c2 INTO sr.nma02_2
 
      #LET l_sql = "SELECT nmc02 FROM ",l_dbs2,"nmc_file",
      LET l_sql = "SELECT nmc02 FROM ",cl_get_target_table(sr.nnw.nnw20,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",sr.nnw.nnw22,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw20) RETURNING l_sql #FUN-A50102
      PREPARE nmc02_p2 FROM l_sql
      DECLARE nmc02_c2 CURSOR FOR nmc02_p2
      OPEN nmc02_c2
      FETCH nmc02_c2 INTO sr.nmc02_2
 
      #LET l_sql = "SELECT azi04,azi07 FROM ",l_dbs2,"azi_file",
      LET l_sql = "SELECT azi04,azi07 FROM ",cl_get_target_table(sr.nnw.nnw20,'azi_file'), #FUN-A50102
                  " WHERE azi01 = '",sr.nnw.nnw23,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw20) RETURNING l_sql #FUN-A50102
      PREPARE azi04_p2 FROM l_sql
      DECLARE azi04_c2 CURSOR FOR azi04_p2
      OPEN azi04_c2
      FETCH azi04_c2 INTO sr.azi04_2,sr.azi07_2
      
      #LET l_sql = "SELECT nma02 FROM ",l_dbs2,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnw.nnw20,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnw.nnw32,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw20) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p5 FROM l_sql
      DECLARE nma02_c5 CURSOR FOR nma02_p5
      OPEN nma02_c5
      FETCH nma02_c5 INTO sr.nma02_5
 
      #LET l_sql = "SELECT nma02 FROM ",l_dbs1,"nma_file",
      LET l_sql = "SELECT nma02 FROM ",cl_get_target_table(sr.nnw.nnw05,'nma_file'), #FUN-A50102
                  " WHERE nma01 = '",sr.nnw.nnw13,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE nma02_p3 FROM l_sql
      DECLARE nma02_c3 CURSOR FOR nma02_p3
      OPEN nma02_c3
      FETCH nma02_c3 INTO sr.nma02_3
 
      #LET l_sql = "SELECT nmc02 FROM ",l_dbs1,"nmc_file",
      LET l_sql = "SELECT nmc02 FROM ",cl_get_target_table(sr.nnw.nnw05,'nmc_file'), #FUN-A50102
                  " WHERE nmc01 = '",sr.nnw.nnw14,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE nmc02_p3 FROM l_sql
      DECLARE nmc02_c3 CURSOR FOR nmc02_p3
      OPEN nmc02_c3
      FETCH nmc02_c3 INTO sr.nmc02_3
 
      #LET l_sql = "SELECT aag02 FROM ",l_dbs1,"aag_file",
      LET l_sql = "SELECT aag02 FROM ",cl_get_target_table(sr.nnw.nnw05,'aag_file'), #FUN-A50102
                  " WHERE aag01 = '",sr.nnw.nnw19,"'",
                   "   AND aag00 = '",g_bookno1,"'"     #NO.FUN-740049
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE aag02_p3 FROM l_sql
      DECLARE aag02_c3 CURSOR FOR aag02_p3
      OPEN aag02_c3
      FETCH aag02_c3 INTO sr.aag02_3
 
      #LET l_sql = "SELECT azi04,azi07 FROM ",l_dbs1,"azi_file",
      LET l_sql = "SELECT azi04,azi07 FROM ",cl_get_target_table(sr.nnw.nnw05,'azi_file'), #FUN-A50102
                  " WHERE azi01 = '",sr.nnw.nnw15,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,sr.nnw.nnw05) RETURNING l_sql #FUN-A50102
      PREPARE azi04_p3 FROM l_sql
      DECLARE azi04_c3 CURSOR FOR azi04_p3
      OPEN azi04_c3
      FETCH azi04_c3 INTO sr.azi04_3,sr.azi07_3
      #No.FUN-690090 --end--
      
#No.FUN-710085--begin
    #TQC-960163---modify---start---
     #EXECUTE insert_prep USING sr.*
      EXECUTE insert_prep USING
         sr.nnw.nnw00,sr.nnw.nnw01,sr.nnw.nnw02,sr.nnw.nnw03,sr.nnw.nnw04,sr.nnw.nnw05,sr.nnw.nnw06,sr.nnw.nnw07,
         sr.nnw.nnw08,sr.nnw.nnw09,sr.nnw.nnw10,sr.nnw.nnw11,sr.nnw.nnw12,sr.nnw.nnw13,sr.nnw.nnw14,sr.nnw.nnw15,
         sr.nnw.nnw16,sr.nnw.nnw17,sr.nnw.nnw18,sr.nnw.nnw19,sr.nnw.nnw20,sr.nnw.nnw21,sr.nnw.nnw22,sr.nnw.nnw23,
         sr.nnw.nnw24,sr.nnw.nnw25,sr.nnw.nnw26,sr.nnw.nnw27,sr.nnw.nnw28,sr.nnw.nnw29,sr.nnw.nnw30,sr.nnw.nnwconf,
         sr.nnw.nnwacti,sr.nnw.nnwuser,sr.nnw.nnwgrup,sr.nnw.nnwmodu,sr.nnw.nnwdate,sr.nnw.nnw121,sr.nnw.nnw191,sr.nnw.nnw271,
         sr.nnw.nnw31,sr.nnw.nnw32,sr.nnx.nnx01,sr.nnx.nnx02,sr.nnx.nnx03,sr.nnx.nnx04,sr.nnx.nnx05,sr.nnx.nnx06,
         sr.nnx.nnx07,sr.nnx.nnx08,sr.nnx.nnx09,sr.nnx.nnx10,sr.nnx.nnx11,sr.nnx.nnx12,sr.nnx.nnx13,sr.nnx.nnx14,
         sr.nnx.nnx15,sr.nnx.nnx16,sr.nnx.nnx17,sr.nnx.nnx18,sr.nnx.nnx19,sr.nnx.nnx20,sr.nnx.nnx21,sr.nnx.nnx201,
         sr.nnx.nnx211,sr.nmydesc,sr.gem02,sr.nml02,sr.azp02_1,sr.azp02_2,sr.nma02_1,sr.nmc02_1,
         sr.aag02_1,sr.azi04_1,sr.azi07_1,sr.nma02_2,sr.nmc02_2,sr.aag02_2,sr.azi04_2,sr.azi07_2,
         sr.nma02_3,sr.nmc02_3,sr.aag02_3,sr.azi04_3,sr.azi07_3,sr.azi04_4,sr.azi07_4,sr.nma02_4,
         sr.nma02_5
         ,"",  l_img_blob,   "N",""      #No.TQC-C10034 add
    #TQC-960163---modify---end---
 
#     OUTPUT TO REPORT anmr930_rep(sr.*)
#No.FUN-710085--end
   END FOREACH
 
#No.FUN-710085--begin                                                                                                               
#    FINISH REPORT anmr930_rep                                                                                                      
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                                                                    
   # LET g_sql = "SELECT * FROM ",l_table CLIPPED  #TQC-730088                                                                      
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                                   
     #是否列印選擇條件
     IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'nnw01,nnw02') RETURNING tm.wc
     ELSE
        LET tm.wc = ' '
     END IF
     LET g_str = tm.wc,";",g_nnw00   #TQC-760017 add g_nnw00
     LET g_cr_table = l_table                 #主報表的temp table名稱        #No.TQC-C10034 add
     LET g_cr_apr_key_f = "nnw01"             #報表主鍵欄位名稱，用"|"隔開   #No.TQC-C10034 add
     IF g_nnw00 ='2' THEN
   #### CALL cl_prt_cs3('anmr930_2',g_sql,g_str)   #TQC-730088                                                                           
        CALL cl_prt_cs3('anmr930','anmr930_2',g_sql,g_str)                                                                                         
     ELSE
   #### CALL cl_prt_cs3('anmr930_1',g_sql,g_str)   #TQC-730088                                                                           
        CALL cl_prt_cs3('anmr930','anmr930_1',g_sql,g_str)                                                                                         
     END IF
#No.FUN-710085--end 
     LET g_prog = l_prog      #TQC-760017 add
 
END FUNCTION
 
#No.FUN-710085--begin                                                                                                               
#REPORT anmr930_rep(sr)
#   DEFINE l_last_sw   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
#          sr          RECORD
#                         nnw      RECORD LIKE nnw_file.*,
#                         nnx      RECORD LIKE nnx_file.*,
#                         nmydesc  LIKE nmy_file.nmydesc,
#                         gem02    LIKE gem_file.gem02,
#                         nml02    LIKE nml_file.nml02,
#                         azp02_1  LIKE azp_file.azp02,
#                         azp02_2  LIKE azp_file.azp02,
#                         nma02_1  LIKE nma_file.nma02,
#                         nmc02_1  LIKE nmc_file.nmc02,
#                         aag02_1  LIKE aag_file.aag02,
#                         azi04_1  LIKE azi_file.azi04,
#                         azi07_1  LIKE azi_file.azi07,
#                         nma02_2  LIKE nma_file.nma02,
#                         nmc02_2  LIKE nmc_file.nmc02,
#                         aag02_2  LIKE aag_file.aag02,
#                         azi04_2  LIKE azi_file.azi04,
#                         azi07_2  LIKE azi_file.azi07,
#                         nma02_3  LIKE nma_file.nma02,
#                         nmc02_3  LIKE nmc_file.nmc02,
#                         aag02_3  LIKE aag_file.aag02,
#                         azi04_3  LIKE azi_file.azi04,
#                         azi07_3  LIKE azi_file.azi07,
#                         azi04_4  LIKE azi_file.azi04,
#                         azi07_4  LIKE azi_file.azi07,
#                         nma02_4  LIKE nma_file.nma02,  #No.FUN-690090
#                         nma02_5  LIKE nma_file.nma02   #No.FUN-690090
#                      END RECORD
#
#   OUTPUT
#      TOP MARGIN 0
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN 5
#      PAGE LENGTH g_page_line
#   ORDER BY sr.nnw.nnw01,sr.nnx.nnx02
#
#   FORMAT
#      PAGE HEADER
#      # No.FUN-670066--begin    
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#         LET g_pageno=g_pageno+1
#         LET pageno_total=PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED ,pageno_total
#      # No.FUN-670066--end
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#         PRINT g_dash[1,g_len]
#         LET l_last_sw = 'n'
#     
#      BEFORE GROUP OF sr.nnw.nnw01
#         SKIP TO TOP OF PAGE
#         #No.TQC-6B0114 --start--  打印內容連在一起的用空格隔開
#         PRINT COLUMN 1,g_x[9],sr.nnw.nnw01,' ',sr.nmydesc,
#               COLUMN 60,g_x[11],sr.nnw.nnw03,' ',sr.gem02,
#               COLUMN 105,g_x[13],sr.nnw.nnw28
#         PRINT COLUMN 1,g_x[10],sr.nnw.nnw02,
#               COLUMN 60,g_x[12],sr.nnw.nnw04,' ',sr.nml02,
#               COLUMN 105,g_x[14],sr.nnw.nnw29
#         PRINT COLUMN  1,g_x[16],sr.nnw.nnw05,' ',sr.azp02_1,
#               COLUMN 105,g_x[15],sr.nnw.nnwconf
#         PRINT COLUMN  1,g_x[29],sr.nnw.nnw20,' ',sr.azp02_2
#         PRINT
#         PRINT COLUMN  1,g_x[17],sr.nnw.nnw06,' ',sr.nma02_1,
#               COLUMN 60,g_x[23],sr.nnw.nnw13,' ',sr.nma02_3,
#               COLUMN 105,g_x[30],sr.nnw.nnw21,' ',sr.nma02_2
#         PRINT COLUMN  1,g_x[18],sr.nnw.nnw07,' ',sr.nmc02_1,
#               COLUMN 60,g_x[24],sr.nnw.nnw14,' ',sr.nmc02_3,
#               COLUMN 105,g_x[49],sr.nnw.nnw22,' ',sr.nmc02_2
#         PRINT COLUMN  1,g_x[19],sr.nnw.nnw08 CLIPPED,' ',cl_numfor(sr.nnw.nnw09,10,sr.azi07_1),
#               COLUMN 60,g_x[25],sr.nnw.nnw15 CLIPPED,' ',cl_numfor(sr.nnw.nnw16,10,sr.azi07_3),
#               COLUMN 105,g_x[50],sr.nnw.nnw23 CLIPPED,' ',cl_numfor(sr.nnw.nnw24,10,sr.azi07_2)
#         PRINT COLUMN  1,g_x[20],cl_numfor(sr.nnw.nnw10,18,sr.azi04_1),
#               COLUMN 60,g_x[26],cl_numfor(sr.nnw.nnw17,18,sr.azi04_3),
#               COLUMN 105,g_x[51],cl_numfor(sr.nnw.nnw25,18,sr.azi04_2)
#         PRINT COLUMN  1,g_x[21],cl_numfor(sr.nnw.nnw11,18,sr.azi04_1),
#               COLUMN 60,g_x[27],cl_numfor(sr.nnw.nnw18,18,sr.azi04_3),
#               COLUMN 105,g_x[52],cl_numfor(sr.nnw.nnw26,18,sr.azi04_2)
##No.FUN-690090 --start--
##        PRINT COLUMN  1,g_x[22],sr.nnw.nnw12,sr.aag02_1,
##              COLUMN 60,g_x[28],sr.nnw.nnw19,sr.aag02_3,
##              COLUMN 105,g_x[53],sr.nnw.nnw27,sr.aag02_2
#         PRINT COLUMN  1,g_x[22],sr.nnx.nnx20,' ',sr.aag02_1,
#               COLUMN 60,g_x[28],sr.nnw.nnw19,' ',sr.aag02_3,
#               COLUMN 105,g_x[53],sr.nnx.nnx21,' ',sr.aag02_2
#         PRINT COLUMN  1,g_x[54],sr.nnw.nnw31,' ',sr.nma02_4,
#               COLUMN 105,g_x[55],sr.nnw.nnw32,' ',sr.nma02_5
##No.FUN-690090 --end--
#         #No.TQC-6B0114 --end--
#         PRINT 
#         PRINT g_dash2[1,g_len]
## No.FUN-670066--begin
##        PRINT COLUMN  1,g_x[36],
##              COLUMN  7,g_x[37],
##              COLUMN 24,g_x[38],
##              COLUMN 35,g_x[39],
##              COLUMN 47,g_x[40],
##              COLUMN 63,g_x[41],
##              COLUMN 83,g_x[42];
##        IF sr.nnw.nnw00 = "1" THEN
##           PRINT COLUMN 103,g_x[43],
##                 COLUMN 123,g_x[44],
##                 COLUMN 143,g_x[45],
##                 COLUMN 163,g_x[46],
##                 COLUMN 191,g_x[47]
##        ELSE
##           PRINT COLUMN  98,g_x[48],      
##                 COLUMN 112,g_x[49],
##                 COLUMN 127,g_x[50],
##                 COLUMN 141,g_x[51],
##                 COLUMN 160,g_x[52],
##                 COLUMN 180,g_x[53]
##       END IF
## No.FUN-670066--end
#      # No.FUN-670066--begin   
#         PRINTX name=H1 g_x[31],g_x[32],g_x[33],
#                        g_x[34],g_x[35],g_x[36],
#                        g_x[37],g_x[38],g_x[39],
#                        g_x[40],g_x[41],g_x[42],
#                        g_x[43],g_x[44],g_x[45],
#                        g_x[46],g_x[47],g_x[48]
#         PRINT g_dash1
#      ON EVERY ROW
#         PRINTX name=D1
#                COLUMN g_c[31],sr.nnx.nnx02 USING "#####",
#                COLUMN g_c[32],sr.nnx.nnx03,
#                COLUMN g_c[33],sr.nnw.nnw04,
#                COLUMN g_c[34],sr.nnx.nnx05,
#                COLUMN g_c[35],cl_numfor(sr.nnx.nnx06,35,sr.azi07_4),
#                COLUMN g_c[36],cl_numfor(sr.nnx.nnx07,36,sr.azi04_4),
#                COLUMN g_c[37],cl_numfor(sr.nnx.nnx08,37,sr.azi04_4);
#          PRINT COLUMN g_c[38] ,cl_numfor(sr.nnx.nnx09,38,sr.azi04_4),
#                COLUMN g_c[39],cl_numfor(sr.nnx.nnx10,39,sr.azi04_4),
#                COLUMN g_c[40],cl_numfor(sr.nnx.nnx11,40,sr.azi04_4),
#                COLUMN g_c[41],cl_numfor(sr.nnx.nnx12,41,sr.azi04_4),
#                COLUMN g_c[42],cl_numfor(sr.nnx.nnx13,42,sr.azi04_4);
#          PRINT COLUMN g_c[43],sr.nnx.nnx14,
#                COLUMN g_c[44],sr.nnx.nnx15,
#                COLUMN g_c[45],sr.nnx.nnx16,
#                COLUMN g_c[46],sr.nnx.nnx17,
#                COLUMN g_c[47],cl_numfor(sr.nnx.nnx18,47,sr.azi04_4),
#                COLUMN g_c[48],cl_numfor(sr.nnx.nnx19,48,sr.azi04_4)
#      # No.FUN-670066--end
## No.FUN-670066--begin
##     ON EVERY ROW
##        PRINT COLUMN  1,sr.nnx.nnx02 USING "#####",
##              COLUMN  7,sr.nnx.nnx03,
##              COLUMN 24,sr.nnx.nnx04,
##              COLUMN 35,sr.nnx.nnx05,
##              COLUMN 44,cl_numfor(sr.nnx.nnx06,10,sr.azi07_4),
##              COLUMN 56,cl_numfor(sr.nnx.nnx07,18,sr.azi04_4),
##              COLUMN 76,cl_numfor(sr.nnx.nnx08,18,sr.azi04_4);
##        IF sr.nnw.nnw00 = "1" THEN
##           PRINT COLUMN  96,cl_numfor(sr.nnx.nnx09,18,sr.azi04_4),
##                 COLUMN 116,cl_numfor(sr.nnx.nnx10,18,sr.azi04_4),
##                 COLUMN 136,cl_numfor(sr.nnx.nnx11,18,sr.azi04_4),
##                 COLUMN 156,cl_numfor(sr.nnx.nnx12,18,sr.azi04_4),
##                 COLUMN 176,cl_numfor(sr.nnx.nnx13,18,sr.azi04_4)
##        ELSE
##           PRINT COLUMN  98,sr.nnx.nnx14,
##                 COLUMN 112,sr.nnx.nnx15,
##                 COLUMN 127,sr.nnx.nnx16,
##                 COLUMN 141,sr.nnx.nnx17,
##                 COLUMN 153,cl_numfor(sr.nnx.nnx18,18,sr.azi04_4),
##                 COLUMN 173,cl_numfor(sr.nnx.nnx19,18,sr.azi04_4)
##        END IF
## No.FUN-670066--end 
#
#      AFTER GROUP OF sr.nnw.nnw01
##        PRINT g_dash[1,g_len]
#
#      ON LAST ROW
## No.FUN-670066--begin 
#     #   PRINT g_dash[1,g_len]
#        LET l_last_sw = 'y'
#     #   PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#     
#      PAGE TRAILER
#         PRINT g_dash[1,g_len]  
#         IF l_last_sw = 'n' THEN 
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#     #      SKIP 2 LINE
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#         END IF
## No.FUN-670066--end
#
#END REPORT
#No.FUN-710085--end 
