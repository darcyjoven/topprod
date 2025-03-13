# Prog. Version..: '5.30.06-13.03.26(00010)'     #
#
# Pattern name...: anmp930.4gl
# Descriptions...: 集團間資金調撥傳票拋轉作業
# Date & Author..: No.FUN-620051 06/03/15 By Mandy
# Date & Author..: No.MOD-640339 06/04/10 By Mandy 帳別應提供工廠之帳別資料查詢視窗
# Date & Author..: No.MOD-640400 06/04/11 By Mandy show產生的傳票號碼時,以一個視窗顯示同時撥出/撥入各傳票號碼.如拋轉時輸入傳票單號/日期作法.
# Modify.........: No.FUN-640142 06/04/14 By Nicola 金額欄位依幣別取位
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-670039 06/07/12 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-670060 06/08/04 By wujie   增加傳參call功能
# Modify.........: No.FUN-680088 06/08/24 By Rayven 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改	
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710020 07/01/12 By rainy aba07 -> VARCHAR(30)
# Modify.........: No.FUN-710024 07/01/18 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-740049 07/04/12 By arman  會計科目加帳套
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 需簽核單別不可自動確認
# Modify.........: No.FUN-810069 08/02/27 By yaofs 項目預算取消abb15的管控    
# Modify.........: No.MOD-850183 08/05/22 By Sarah 將IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF這行mark掉
#                                                  將IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN改成IF g_aba.abamksg='N' THEN
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.FUN-980005 09/08/19 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/15 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/17 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.TQC-960310 09/10/10 By baofei 修改p930_del_tmn2和p930_del_tmn1的SQL組合錯誤                                   
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No.CHI-9A0021 09/10/16 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法 
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:FUN-A10006 10/01/13 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: No:MOD-A80136 10/08/18 By Dido 新增至 aba_file 時,提供 aba37 預設值 
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file
# Modify.........: No:TQC-BA0149 11/10/25 By yinhy 拋轉總帳時附件匯總張數錯誤
# Modify.........: No:CHI-CB0004 12/11/12 By Belle 修改總號計算方式
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:MOD-CB0120 13/02/04 By jt_chen 調整累加值變數預設，已正確的補到缺號。

IMPORT os   #No.FUN-9C0009
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_wc,g_sql       string                  #No.FUN-580092 HCN
DEFINE g_dbs_gl 	LIKE type_file.chr21    #No.FUN-680107 VARCHAR(21)
DEFINE gl_no		LIKE aba_file.aba01     #No.FUN-680107 VARCHAR(16)	# 傳票單號
DEFINE gl_no1   	LIKE aba_file.aba01     #No.FUN-680107 VARCHAR(16)	#No.FUN-680088
DEFINE gl_no_b,gl_no_e	LIKE aba_file.aba01     #No.FUN-680107 VARCHAR(16)	# Generated 傳票單號 #拋轉總帳起始傳票編號/截止傳票編號
DEFINE gl_no1_b,gl_no1_e  LIKE aba_file.aba01   #No.FUN-680107 VARCHAR(16) #No.FUN-680088
DEFINE p_plant          LIKE tmn_file.tmn01     #No.FUN-680107 VARCHAR(12)	
DEFINE p_plant_old      LIKE tmn_file.tmn01     #No.FUN-680107 VARCHAR(12) #No.FUN-570090  --add     
DEFINE p_bookno         LIKE aaa_file.aaa01     #No.FUN-670039 	
DEFINE p_bookno1        LIKE aaa_file.aaa01     #No.FUN-680088 	
DEFINE gl_date	        LIKE type_file.dat      #No.FUN-680107 DATE
DEFINE g_t1		LIKE oay_file.oayslip   #NO:6842  #No.FUN-680107 VARCHAR(5)
                                                #No.FUN-560190
DEFINE gl_tran		LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE gl_seq    	LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1) # 傳票區分項目
DEFINE b_user,e_user	LIKE tmn_file.tmn01     #No.FUN-680107 VARCHAR(10)
DEFINE g_yy,g_mm	LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE g_statu          LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_aba01t         LIKE aac_file.aac01     #No.FUN-680107 VARCHAR(5) #No.FUN-560190
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680107 SMALLINT
#------for ora修改-------------------
DEFINE g_system         LIKE aba_file.aba06     #No.FUN-680107 VARCHAR(2)
DEFINE g_zero           LIKE aba_file.aba08     #No.FUN-680107 decimal(15,3)
DEFINE g_zero1          LIKE aba_file.aba20     #No.FUN-680107 VARCHAR(01)
DEFINE g_N              LIKE aba_file.aba12     #No.FUN-680107 VARCHAR(1)
DEFINE g_y              LIKE aba_file.abaacti   #No.FUN-680107 VARCHAR(1)
DEFINE g_flag           LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
DEFINE g_aaz85          LIKE aaz_file.aaz85     #傳票是否自動確認 no.3432
DEFINE g_cnt            LIKE type_file.num10    #No.FUN-680107 INTEGER
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_j              LIKE type_file.num5     #No.FUN-680107 SMALLINT #No.FUN-570090  --add   
DEFINE g_change_lang    LIKE type_file.chr1     #No.FUN-680107 VARCHAR(01) #是否有做語言切換 No.FUN-570127
#--------------以下變數為寫anmp930 mandy add
DEFINE g_choice         LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1) 
DEFINE g_npp00          LIKE npp_file.npp00
DEFINE g_rec_b          LIKE type_file.num5     #單身筆數  #No.FUN-680107 SMALLINT
DEFINE l_ac             LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
DEFINE g_plant_1        DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
                        p_plant       LIKE nnv_file.nnv05,
                        gl_dbs        LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21) #DataBase Name #例如 inf==>ds:   ora==>ds.
                        p_bookno      LIKE aba_file.aba00,
                        gl_no         LIKE aba_file.aba01,
                        p_bookno1     LIKE aba_file.aba00,    #No.FUN-680088
                        gl_no1        LIKE aba_file.aba01,    #No.FUN-680088
                        gl_date       LIKE aba_file.aba02,
                        yy            LIKE type_file.num5,    #No.FUN-680107 SMALLINT #會計年度
                        mm            LIKE type_file.num5     #No.FUN-680107 SMALLINT #期間
                        END RECORD
DEFINE g_plant_t        RECORD                                #程式變數(Program Variables)
                        p_plant       LIKE nnv_file.nnv05,
                        gl_dbs        LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21) #DataBase Name #例如 inf==>ds:   ora==>ds.
                        p_bookno      LIKE aba_file.aba00,
                        gl_no         LIKE aba_file.aba01,
                        p_bookno1     LIKE aba_file.aba00,    #No.FUN-680088
                        gl_no1        LIKE aba_file.aba01,    #No.FUN-680088
                        gl_date       LIKE aba_file.aba02,
                        yy            LIKE type_file.num5,    #No.FUN-680107 SMALLINT #會計年度
                        mm            LIKE type_file.num5     #No.FUN-680107 SMALLINT #期間
                        END RECORD
#FUN-640400 -------------add-----------
DEFINE g_show_msg       DYNAMIC ARRAY OF RECORD               #程式變數(Program Variables)
                        p_plant       LIKE azp_file.azp01,
                        p_bookno      LIKE aba_file.aba00,
                        gl_no_b       LIKE aba_file.aba01,    #起始
                        gl_no_e       LIKE aba_file.aba01,    #截止
                        p_bookno1     LIKE aba_file.aba00,    #No.FUN-680088
                        gl_no1_b      LIKE aba_file.aba01,    #No.FUN-680088
                        gl_no1_e      LIKE aba_file.aba01,    #No.FUN-680088
                        gl_date       LIKE aba_file.aba02,
                        memo          LIKE ze_file.ze03       #備註:若沒有產生傳票加備註
                        END RECORD
DEFINE g_msg            STRING
DEFINE g_msg2           STRING
DEFINE g_title_f1       STRING
DEFINE g_title_f2       STRING
DEFINE g_title_f3       STRING
DEFINE g_title_f4       STRING
DEFINE g_title_f5       STRING
DEFINE g_title_f6       STRING
DEFINE g_title_f21      STRING                                #No.FUN-680088
DEFINE g_title_f31      STRING                                #No.FUN-680088
DEFINE g_title_f41      STRING                                #No.FUN-680088 
#FUN-64400 -------------end-----------
#DEFINE t_azi04          LIKE azi_file.azi04                   #No.FUN-640142 #NO.CHI-6A0004
DEFINE g_cbg            LIKE type_file.chr1                   #No.FUN-680107 VARCHAR(1) #No.FUN-670060   
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8          #No.FUN-6A0082
    DEFINE l_flag      LIKE type_file.chr1                    #->No.FUN-570127  #No.FUN-680107 VARCHAR(1)
    DEFINE ls_date     STRING                                 #->No.FUN-570127
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
#No.FUN-670060--begin
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET b_user   = ARG_VAL(2)             #資料來源營運中心
   LET e_user   = ARG_VAL(3)             #資料來源
   LET p_bookno = ARG_VAL(4)             #總帳帳別編號
   LET gl_date  = cl_batch_bg_date_convert(ls_date)   #總帳傳票日期
   LET g_choice = ARG_VAL(5)             #作業資料選擇
   LET gl_tran  = ARG_VAL(6)             #拋轉摘要
   LET gl_seq   = ARG_VAL(7)             #傳票匯總方式
   LET g_cbg = ARG_VAL(8)             #背景作業
   LET p_bookno1 = ARG_VAL(9)         #No.FUN-680088
   IF cl_null(g_cbg) THEN
      LET g_cbg = "N"
   END IF
#No.FUN-670060--end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add
 
   LET g_j = 0   #MOD-CB0120 add
   WHILE TRUE
      CALL p930_create_tmp()
      IF g_cbg = "N" THEN     #No.FUN-670060
         CALL p930_ask()               # Ask for first_flag, data range or exist
         IF g_rec_b = 0 THEN
             #無符合條件範圍的資料可做拋,請重新輸入條件.
             CALL cl_err('','anm-926',1)
             CONTINUE WHILE
         END IF
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            LET g_wc=cl_replace_str(g_wc, "nnv", "npp")
            CALL s_showmsg_init()                       #No.FUN-710024
            FOR g_i = 1 TO g_rec_b
                #No.FUN-710024--begin
                IF g_success='N' THEN                                                                                                          
                   LET g_totsuccess='N'                                                                                                       
                   LET g_success="Y"                                                                                                          
                END IF             
                #No.FUN-710024--end
                LET l_ac = g_i
                CALL p930_t('0')  #No.FUN-680088 add '0'
                #No.FUN-680088 --start--
                IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                   CALL p930_t('1')
                END IF
                #No.FUN-680088 --end--
                IF g_success = 'N' THEN
                    EXIT FOR
                END IF
                #MOD-640400-----------add------------------
                LET g_show_msg[g_i].p_plant =g_plant_1[g_i].p_plant
                LET g_show_msg[g_i].p_bookno=g_plant_1[g_i].p_bookno
                IF NOT cl_null(gl_no_b) AND NOT cl_null(gl_no_e) THEN
                    LET g_show_msg[g_i].gl_no_b =gl_no_b
                    LET g_show_msg[g_i].gl_no_e =gl_no_e
                ELSE
                    #此營運中心沒有產生傳票
                    CALL cl_getmsg('anm-928',g_lang) RETURNING g_show_msg[g_i].memo 
                END IF
                #No.FUN-680088 --start--
                IF g_aza.aza63 = 'Y' THEN
                   LET g_show_msg[g_i].p_bookno1=g_plant_1[g_i].p_bookno1
                   IF NOT cl_null(gl_no1_b) AND NOT cl_null(gl_no1_e) THEN
                       LET g_show_msg[g_i].gl_no1_b =gl_no1_b
                       LET g_show_msg[g_i].gl_no1_e =gl_no1_e
                   ELSE
                       CALL cl_getmsg('anm-928',g_lang) RETURNING g_show_msg[g_i].memo
                   END IF
                END IF
                #No.FUN-680088 --end--
                LET g_show_msg[g_i].gl_date =g_plant_1[g_i].gl_date
                #MOD-640400-----------end------------------
 
                #刪除傳票缺號檔
       #         LET g_sql = "DELETE FROM",g_plant_1[l_ac].gl_dbs,"tmn_file",   #TQC-960310  
                #LET g_sql = "DELETE FROM ",g_plant_1[l_ac].gl_dbs,"tmn_file",  #TQC-960310
                LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'tmn_file'), #FUN-A50102              
                            " WHERE tmn01 ='", g_plant_1[l_ac].p_plant,"'", 
                            "   AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y') "
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
                PREPARE p930_del_tmn1 FROM g_sql
                EXECUTE p930_del_tmn1
            END FOR
            #No.FUN-710024--begin
            IF g_totsuccess="N" THEN                                                                                                         
               LET g_success="N"                                                                                                             
            END IF 
            #No.FUN-710024--end 
            #MOD-640400--------------add-----------------------
            IF g_success = 'Y' THEN
                #以陣列方式show出所產生的資料
                LET g_msg = NULL
                LET g_msg2= NULL
                LET g_title_f1 = NULL
                LET g_title_f2 = NULL
                LET g_title_f3 = NULL
                LET g_title_f4 = NULL
                LET g_title_f5 = NULL
                LET g_title_f6 = NULL
                CALL cl_getmsg('apm-574',g_lang)     RETURNING g_msg
                CALL cl_get_feldname('azp01',g_lang) RETURNING g_title_f1
                CALL cl_get_feldname('aba00',g_lang) RETURNING g_title_f2
                CALL cl_getmsg('anm-947',g_lang)     RETURNING g_title_f3
                CALL cl_getmsg('anm-948',g_lang)     RETURNING g_title_f4
                #No.FUN-680088 --start--
                IF g_aza.aza63 = 'Y' THEN
                   CALL cl_get_feldname('aba00',g_lang) RETURNING g_title_f21
                   LET g_title_f21 = g_title_f21 CLIPPED,'-2|'
                   CALL cl_getmsg('anm-947',g_lang)     RETURNING g_title_f31
                   LET g_title_f31 = g_title_f31 CLIPPED,'-2|'
                   CALL cl_getmsg('anm-948',g_lang)     RETURNING g_title_f41
                   LET g_title_f41 = g_title_f41 CLIPPED,'-2|'
                END IF
                #No.FUN-680088 --end--
                CALL cl_get_feldname('aba02',g_lang) RETURNING g_title_f5
                CALL cl_getmsg('anm-949',g_lang)     RETURNING g_title_f6
#               LET g_msg2 = g_title_f1 CLIPPED,'|',g_title_f2 CLIPPED,'|',g_title_f3 CLIPPED,'|',   #No.FUN-680088 mark
#                            g_title_f4 CLIPPED,'|',g_title_f5 CLIPPED,'|',g_title_f6 CLIPPED        #No.FUN-680088 mark
                LET g_msg2 = g_title_f1 CLIPPED,'|',g_title_f2 CLIPPED,'|',g_title_f3 CLIPPED,'|',   #No.FUN-680088
                             g_title_f4 CLIPPED,'|',g_title_f21 CLIPPED,'|',g_title_f31 CLIPPED,'|', #No.FUN-680088
                             g_title_f41 CLIPPED,'|',g_title_f5 CLIPPED,'|',g_title_f6 CLIPPED       #No.FUN-680088
                CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
            END IF  
            #MOD-640400--------------end-----------------------
            CALL s_showmsg()          #No.FUN-710024
            IF g_success = 'Y' THEN
               IF cl_confirm('anm-929') THEN
                   COMMIT WORK
                   CALL cl_end2(1) RETURNING l_flag
               ELSE
                   ROLLBACK WORK
                   CONTINUE WHILE
               END IF
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p930
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
#No.FUN-670060--begin
         LET g_apz.apz02b = p_bookno  # 得帳別
         CASE g_choice
             WHEN '1'
                  LET g_npp00 = 21
             WHEN '2'
                  LET g_npp00 = 22
             WHEN '3'
                  LET g_npp00 = 23
         END CASE 
         CALL p930_get_plant()
         CLOSE WINDOW p930_a
         IF INT_FLAG THEN
             LET INT_FLAG = 0
             EXIT WHILE
         END IF
         LET g_success = 'Y'
         BEGIN WORK
         LET g_wc=cl_replace_str(g_wc, "nnv", "npp")
         CALL s_showmsg_init()                       #No.FUN-710024
         FOR g_i = 1 TO g_rec_b
             LET l_ac = g_i
             CALL p930_t('0')  #No.FUN-680088 add '0'
             #No.FUN-680088 --start--
             IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                CALL p930_t('1')
             END IF
             #No.FUN-680088 --end--
             IF g_success = 'N' THEN
                 EXIT FOR
             END IF
             #MOD-640400-----------add------------------
             LET g_show_msg[g_i].p_plant =g_plant_1[g_i].p_plant
             LET g_show_msg[g_i].p_bookno=g_plant_1[g_i].p_bookno
             IF NOT cl_null(gl_no_b) AND NOT cl_null(gl_no_e) THEN
                 LET g_show_msg[g_i].gl_no_b =gl_no_b
                 LET g_show_msg[g_i].gl_no_e =gl_no_e
             ELSE
                 #此營運中心沒有產生傳票
                 CALL cl_getmsg('anm-928',g_lang) RETURNING g_show_msg[g_i].memo 
             END IF
             #No.FUN-680088 --start--
             IF g_aza.aza63 = 'Y' THEN
                LET g_show_msg[g_i].p_bookno1=g_plant_1[g_i].p_bookno1
                IF NOT cl_null(gl_no1_b) AND NOT cl_null(gl_no1_e) THEN
                    LET g_show_msg[g_i].gl_no1_b =gl_no1_b
                    LET g_show_msg[g_i].gl_no1_e =gl_no1_e
                ELSE
                    CALL cl_getmsg('anm-928',g_lang) RETURNING g_show_msg[g_i].memo
                END IF
             END IF
             #No.FUN-680088 --end--
             LET g_show_msg[g_i].gl_date =g_plant_1[g_i].gl_date
             #MOD-640400-----------end------------------
 
             #刪除傳票缺號檔
          #   LET g_sql = "DELETE FROM",g_plant_1[l_ac].gl_dbs,"tmn_file",  #TQC-960310  
             #LET g_sql = "DELETE FROM ",g_plant_1[l_ac].gl_dbs,"tmn_file",  #TQC-960310
          LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'tmn_file'), #FUN-A50102  
                         " WHERE tmn01 ='", g_plant_1[l_ac].p_plant,"'", 
                         "   AND tmn02 IN (SELECT tc_tmp02 FROM agl_tmp_file WHERE tc_tmp00 = 'Y') "
 	         CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
             CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
             PREPARE p930_del_tmn11 FROM g_sql
             EXECUTE p930_del_tmn11
         END FOR
         #MOD-640400--------------add-----------------------
         IF g_success = 'Y' THEN
             #以陣列方式show出所產生的資料
             LET g_msg = NULL
             LET g_msg2= NULL
             LET g_title_f1 = NULL
             LET g_title_f2 = NULL
             LET g_title_f3 = NULL
             LET g_title_f4 = NULL
             LET g_title_f5 = NULL
             LET g_title_f6 = NULL
             CALL cl_getmsg('apm-574',g_lang)     RETURNING g_msg
             CALL cl_get_feldname('azp01',g_lang) RETURNING g_title_f1
             CALL cl_get_feldname('aba00',g_lang) RETURNING g_title_f2
             CALL cl_getmsg('anm-947',g_lang)     RETURNING g_title_f3
             CALL cl_getmsg('anm-948',g_lang)     RETURNING g_title_f4
             #No.FUN-680088 --start--
             IF g_aza.aza63 = 'Y' THEN
                CALL cl_get_feldname('aba00',g_lang) RETURNING g_title_f21
                LET g_title_f21 = g_title_f21 CLIPPED,'-2|'
                CALL cl_getmsg('anm-947',g_lang)     RETURNING g_title_f31
                LET g_title_f31 = g_title_f31 CLIPPED,'-2|'
                CALL cl_getmsg('anm-948',g_lang)     RETURNING g_title_f41
                LET g_title_f41 = g_title_f41 CLIPPED,'-2|'
             END IF
             #No.FUN-680088 --end--
             CALL cl_get_feldname('aba02',g_lang) RETURNING g_title_f5
             CALL cl_getmsg('anm-949',g_lang)     RETURNING g_title_f6
#            LET g_msg2 = g_title_f1 CLIPPED,'|',g_title_f2 CLIPPED,'|',g_title_f3 CLIPPED,'|',   #No.FUN-680088 mark
#                         g_title_f4 CLIPPED,'|',g_title_f5 CLIPPED,'|',g_title_f6 CLIPPED        #No.FUN-680088 mark
             LET g_msg2 = g_title_f1 CLIPPED,'|',g_title_f2 CLIPPED,'|',g_title_f3 CLIPPED,'|',   #No.FUN-680088
                          g_title_f4 CLIPPED,'|',g_title_f21 CLIPPED,'|',g_title_f31 CLIPPED,'|', #No.FUN-680088
                          g_title_f41 CLIPPED,'|',g_title_f5 CLIPPED,'|',g_title_f6 CLIPPED       #No.FUN-680088
             CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
         END IF  
         CALL s_showmsg()          #No.FUN-710024
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
#No.FUN-670060--end
      END IF
   END WHILE
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
 
FUNCTION p930_ask()
   IF STATUS THEN 
       LET g_success = 'N'
       CALL cl_err('create tmp',STATUS,1) 
       RETURN
   END IF  
 
   DROP TABLE agl_tmp_file    
#No.FUN-680107 --START
#  CREATE TEMP TABLE agl_tmp_file         
#  (tc_tmp00     VARCHAR(1) NOT NULL,      
#   tc_tmp01     SMALLINT,             
#   tc_tmp02     VARCHAR(20),
#   tc_tmp03     VARCHAR(5))  #No.FUN-680088 add tc_tmp03
   CREATE TEMP TABLE agl_tmp_file(
       tc_tmp00 LIKE type_file.chr1 NOT NULL,
       tc_tmp01 LIKE type_file.num5,  
       tc_tmp02 LIKE type_file.chr20, 
       tc_tmp03 LIKE oay_file.oayslip)
#No.FUN-680107 --END 
 
    IF STATUS THEN 
       CALL cl_err('create tmp',STATUS,1) 
       LET g_success = 'N'
   END IF  
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-680088 add tc_tmp03
   IF STATUS THEN CALL cl_err('create index',STATUS,0) 
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM 
   END IF 
 
   OPEN WINDOW p930 AT p_row,p_col WITH FORM "anm/42f/anmp930" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_init()
  WHILE TRUE
   CLEAR FORM
   LET g_choice = '1'
   INPUT g_choice WITHOUT DEFAULTS FROM FORMONLY.choice
          ATTRIBUTE(UNBUFFERED)  
      AFTER FIELD choice
         CASE g_choice
             WHEN '1'
                  LET g_npp00 = 21
             WHEN '2'
                  LET g_npp00 = 22
             WHEN '3'
                  LET g_npp00 = 23
         END CASE 
      AFTER INPUT
         IF INT_FLAG THEN 
            EXIT INPUT
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION locale
            LET g_change_lang = TRUE        
            EXIT INPUT
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p930
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
 
   CONSTRUCT BY NAME g_wc ON nnv01,nnv02
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
      ON ACTION locale             
         LET g_change_lang = TRUE   
         EXIT CONSTRUCT
   
      ON ACTION exit              
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnvuser', 'nnvgrup') #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p930
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
 
   LET b_user  = '0'
#  LET e_user  = 'Z' #No.FUN-680088 mark
   LET e_user  = 'z' #No.FUN-680088
   LET gl_seq  = '0' #傳票匯總方式(0:全部 1:依單號 2:依日期)
   LET gl_tran = 'Y' #拋轉摘要否
   LET g_cbg = "N" #背景執行    #No.FUN-670060
   INPUT BY NAME b_user,e_user,gl_tran,gl_seq
      WITHOUT DEFAULTS  ATTRIBUTE(UNBUFFERED)  
 
      AFTER FIELD e_user
         IF e_user = 'Z' THEN
            LET e_user='z' 
            DISPLAY BY NAME e_user 
         END IF
 
      AFTER FIELD gl_seq  
         IF NOT cl_null(gl_seq) THEN
            IF gl_seq NOT MATCHES '[012]' THEN
               NEXT FIELD gl_seq 
            END IF
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN 
            EXIT INPUT
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
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION locale
            LET g_change_lang = TRUE        
            EXIT INPUT
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p930
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
      EXIT PROGRAM
   END IF
   CALL p930_get_plant()
   CLOSE WINDOW p930_a
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       CONTINUE WHILE
   END IF
   EXIT WHILE
  END WHILE
END FUNCTION
 
FUNCTION p930_get_plant()
   OPEN WINDOW p930_a AT p_row,p_col WITH FORM "anm/42f/anmp930_a" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_load_act_sys(NULL)             #No.FUN-670060
    CALL cl_ui_locale("anmp930_a")
 
    CALL cl_set_comp_visible("gl_dbs,yy,mm",FALSE) #mandy
 
    #No.FUN-680088 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)
    END IF
    #No.FUN-680088 --end--
 
    CALL p930_b_fill()
    IF g_rec_b = 0 THEN
        #無符合條件範圍的資料可做拋轉
        RETURN
    END IF
    CALL p930_b()
END FUNCTION
 
FUNCTION p930_b_fill()              #BODY FILL UP
DEFINE
   l_wc            STRING
 
   CASE g_choice
        WHEN '1' #調撥
             LET g_sql = "SELECT UNIQUE nnv05 ",
                         "  FROM nnv_file ",
                         " WHERE ",g_wc CLIPPED,                     
                         " UNION ",
                         "SELECT UNIQUE nnv20 ",
                         "  FROM nnv_file ",
                         " WHERE ",g_wc CLIPPED
        WHEN '2' #還本
             LET l_wc=cl_replace_str(g_wc, "nnv", "nnw")
             LET g_sql = "SELECT UNIQUE nnw05 ",
                         "  FROM nnw_file ",
                         " WHERE ",l_wc CLIPPED,                     
                         "   AND nnw00 = '1' ",
                         " UNION ",
                         "SELECT UNIQUE nnw20 ",
                         "  FROM nnw_file ",
                         " WHERE ",l_wc CLIPPED,
                         "   AND nnw00 = '1' "
        WHEN '3' #還息
             LET l_wc=cl_replace_str(g_wc, "nnv", "nnw")
             LET g_sql = "SELECT UNIQUE nnw05 ",
                         "  FROM nnw_file ",
                         " WHERE ",l_wc CLIPPED,                     
                         "   AND nnw00 = '2' ",
                         " UNION ",
                         "SELECT UNIQUE nnw20 ",
                         "  FROM nnw_file ",
                         " WHERE ",l_wc CLIPPED,
                         "   AND nnw00 = '2' "
   END CASE 
   PREPARE p930_nnv_pre FROM g_sql
   DECLARE nnv_curs CURSOR FOR p930_nnv_pre
   CALL g_plant_1.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH nnv_curs INTO g_plant_1[g_cnt].p_plant
      IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      LET g_plant_1[g_cnt].gl_date = g_today
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_plant_1.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
END FUNCTION
 
#單身
FUNCTION p930_b()
  DEFINE l_azp03    LIKE azp_file.azp03    #MOD-640339 add
  DEFINE l_azp03_1  LIKE azp_file.azp03    #No.FUN-680088
  DEFINE l_aaa07    LIKE aaa_file.aaa07
  DEFINE l_aaa07_1  LIKE aaa_file.aaa07    #No.FUN-680088
  DEFINE l_azn02    LIKE azn_file.azn02
  DEFINE l_azn04    LIKE azn_file.azn04
  DEFINE li_result  LIKE type_file.num5    #No.FUN-680107 SMALLINT
  DEFINE   l_no           LIKE type_file.chr3    #No.FUN-840125                
  DEFINE   l_no1          LIKE type_file.chr3    #No.FUN-840125                
  DEFINE   l_aac03        LIKE aac_file.aac03    #No.FUN-840125  
  DEFINE   l_aac03_1      LIKE aac_file.aac03    #No.FUN-840125  
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態    #No.FUN-680107 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否    #No.FUN-680107 VARCHAR(01)
    l_allow_delete  LIKE type_file.chr1    #可刪除否    #No.FUN-680107 VARCHAR(1)
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = "FALSE" 
    LET l_allow_delete = "FALSE"
 
    INPUT ARRAY g_plant_1 WITHOUT DEFAULTS FROM s_plant.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(1)
          END IF
 
      BEFORE ROW
          LET p_cmd = ''
          LET l_ac = ARR_CURR()
          IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_plant_t.* = g_plant_1[l_ac].*  #BACKUP
          END IF
 
      BEFORE FIELD p_bookno
         CALL s_getdbs_curr(g_plant_1[l_ac].p_plant) RETURNING g_plant_1[l_ac].gl_dbs #得資料庫名稱
         DISPLAY BY NAME g_plant_1[l_ac].gl_dbs
         IF cl_null(g_plant_1[l_ac].p_bookno) THEN
             #LET g_sql="SELECT nmz02b FROM ",g_plant_1[l_ac].gl_dbs CLIPPED,"nmz_file ",
             LET g_sql="SELECT nmz02b FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'nmz_file'), #FUN-A50102
                       " WHERE nmz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
             PREPARE p930_nmz02b_p FROM g_sql
             DECLARE p930_nmz02b_cus CURSOR FOR p930_nmz02b_p
             OPEN p930_nmz02b_cus
             FETCH p930_nmz02b_cus INTO g_plant_1[l_ac].p_bookno
             DISPLAY BY NAME g_plant_1[l_ac].p_bookno
         END IF
 
      AFTER FIELD p_bookno
         IF NOT cl_null(g_plant_1[l_ac].p_bookno) THEN
            #No.FUN-680088 --start--
            IF g_plant_1[l_ac].p_bookno1 = g_plant_1[l_ac].p_bookno THEN
               CALL cl_err('','aap-987',1)
               NEXT FIELD p_bookno
            END IF
            #No.FUN-680088 --end--
            LET g_sql = "SELECT aaa07 ",
                        #"  FROM ",g_plant_1[l_ac].gl_dbs," aaa_file ",
                        "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aaa_file'), #FUN-A50102
                        " WHERE aaa01 = '",g_plant_1[l_ac].p_bookno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
            PREPARE p930_aaa_pre FROM g_sql
            DECLARE aaa_curs CURSOR FOR p930_aaa_pre
            OPEN aaa_curs
            FETCH aaa_curs INTO l_aaa07
            IF STATUS THEN
                CALL cl_err('sel aaa',100,1)
                NEXT FIELD p_bookno
            END IF
         END IF
 
      #No.FUN-680088 --start--
      BEFORE FIELD p_bookno1
         CALL s_getdbs_curr(g_plant_1[l_ac].p_plant) RETURNING g_plant_1[l_ac].gl_dbs #得資料庫名稱
         DISPLAY BY NAME g_plant_1[l_ac].gl_dbs
         IF cl_null(g_plant_1[l_ac].p_bookno1) THEN
             #LET g_sql="SELECT nmz02c FROM ",g_plant_1[l_ac].gl_dbs CLIPPED,"nmz_file ",
             LET g_sql="SELECT nmz02c FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'nmz_file'), #FUN-A50102
                       " WHERE nmz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
             PREPARE p930_nmz02c_p FROM g_sql
             DECLARE p930_nmz02c_cus CURSOR FOR p930_nmz02c_p
             OPEN p930_nmz02c_cus
             FETCH p930_nmz02c_cus INTO g_plant_1[l_ac].p_bookno1
             DISPLAY BY NAME g_plant_1[l_ac].p_bookno1
         END IF
 
      AFTER FIELD p_bookno1
         IF NOT cl_null(g_plant_1[l_ac].p_bookno1) THEN
            IF g_plant_1[l_ac].p_bookno1 = g_plant_1[l_ac].p_bookno THEN
               CALL cl_err('','aap-987',1)
               NEXT FIELD p_bookno1
            END IF
            LET g_sql = "SELECT aaa07 ",
                        #"  FROM ",g_plant_1[l_ac].gl_dbs," aaa_file ",
                        "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aaa_file'), #FUN-A50102
                        " WHERE aaa01 = '",g_plant_1[l_ac].p_bookno1,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
            PREPARE p930_aaa_pre1 FROM g_sql
            DECLARE aaa_curs1 CURSOR FOR p930_aaa_pre1
            OPEN aaa_curs1
            FETCH aaa_curs1 INTO l_aaa07_1
            IF STATUS THEN
                CALL cl_err('sel aaa',100,1)
                NEXT FIELD p_bookno1
            END IF
         END IF
      #No.FUN-680088 --end--
 
      AFTER FIELD gl_no
#        IF NOT cl_null(gl_no) THEN  #No.FUN-680088 mark
         IF NOT cl_null(g_plant_1[l_ac].gl_no) THEN #No.FUN-680088
           #CALL s_check_no("agl",g_plant_1[l_ac].gl_no,"","1","aac_file","aac01",g_plant_1[l_ac].gl_dbs)     #FUN-980094 mark
            CALL s_check_no("agl",g_plant_1[l_ac].gl_no,"","1","aac_file","aac01",g_plant_1[l_ac].p_plant)    #FUN-980094
            RETURNING li_result,gl_no
            IF (NOT li_result) THEN                                                                                                 
                NEXT FIELD gl_no             
            END IF       
            #No.FUN-840125---Begin                                                  
            LET l_no = gl_no                                                        
            SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no               
            IF l_aac03 != '0' THEN                                                  
               CALL cl_err(gl_no,'agl-991',0)                                       
               NEXT FIELD gl_no                                                     
            END IF                                                                  
            #No.FUN-840125---End                     
         END IF
 
      #No.FUN-680088 --start--
      AFTER FIELD gl_no1
         IF NOT cl_null(g_plant_1[l_ac].gl_no1) THEN
           #CALL s_check_no("agl",g_plant_1[l_ac].gl_no1,"","1","aac_file","aac01",g_plant_1[l_ac].gl_dbs)     #FUN-980094 mark
            CALL s_check_no("agl",g_plant_1[l_ac].gl_no1,"","1","aac_file","aac01",g_plant_1[l_ac].p_plant)    #FUN-980094
            RETURNING li_result,gl_no1
            IF (NOT li_result) THEN                                                                                                 
                NEXT FIELD gl_no1             
            END IF  
            #No.FUN-840125---Begin                                                  
            LET l_no1 = gl_no1                                                        
            SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1               
            IF l_aac03_1 != '0' THEN                                                  
               CALL cl_err(gl_no1,'agl-991',0)                                       
               NEXT FIELD gl_no1                                                     
            END IF                                                                  
            #No.FUN-840125---End                          
         END IF
      #No.FUN-680088 --end--
 
      BEFORE FIELD gl_date 
         IF cl_null(g_plant_1[l_ac].gl_date) THEN 
             LET g_plant_1[l_ac].gl_date = g_today
             DISPLAY BY NAME g_plant_1[l_ac].gl_date
         END IF
 
     #AFTER FIELD gl_date
      AFTER ROW
         IF NOT cl_null(g_plant_1[l_ac].gl_date) THEN 
            IF g_plant_1[l_ac].gl_date <= l_aaa07 THEN    
               CALL cl_err('','axm-164',1) 
               NEXT FIELD gl_date
            END IF
            #No.FUN-680088 --start--
            IF g_aza.aza63 = 'Y' THEN
               LET g_sql = "SELECT aznn02,aznn04 ",
                           #"  FROM ",g_plant_1[l_ac].gl_dbs,"aznn_file ",
                           "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aznn_file'), #FUN-A50102
                           " WHERE aznn00 = '",g_plant_1[l_ac].p_bookno,"'",
                           "   AND aznn01 = '",g_plant_1[l_ac].gl_date,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
               PREPARE p930_aznn_pre FROM g_sql
               DECLARE aznn_curs CURSOR FOR p930_aznn_pre
               OPEN aznn_curs
               FETCH aznn_curs INTO g_plant_1[l_ac].yy,g_plant_1[l_ac].mm 
            ELSE
            #No.FUN-680088 --end--
               LET g_sql = "SELECT azn02,azn04 ",
                           #"  FROM ",g_plant_1[l_ac].gl_dbs,"azn_file ",
                           "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'azn_file'), #FUN-A50102
                           " WHERE azn01 = '",g_plant_1[l_ac].gl_date,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
               PREPARE p930_azn_pre FROM g_sql
               DECLARE azn_curs CURSOR FOR p930_azn_pre
               OPEN azn_curs
               FETCH azn_curs INTO g_plant_1[l_ac].yy,g_plant_1[l_ac].mm 
            END IF  #No.FUN-680088
            IF STATUS THEN
              #MOD-640339 ------add-----
              #沒有設定此日期的會計期間資料,請重新輸入!
              #CALL cl_err('sel azn:',SQLCA.sqlcode,1)
               CALL cl_err(g_plant_1[l_ac].gl_date,'anm-946',1)
               NEXT FIELD p_bookno 
              #MOD-640339 ------end-----
            END IF
            #No.FUN-680088 --start--
            IF g_aza.aza63 = 'Y' THEN
               LET g_sql = "SELECT aznn02,aznn04 ",
                           #"  FROM ",g_plant_1[l_ac].gl_dbs,"aznn_file ",
                           "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aznn_file'), #FUN-A50102
                           " WHERE aznn00 = '",g_plant_1[l_ac].p_bookno1,"'",
                           "   AND aznn01 = '",g_plant_1[l_ac].gl_date,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
               PREPARE p930_aznn_pre1 FROM g_sql
               DECLARE aznn_curs1 CURSOR FOR p930_aznn_pre1
               OPEN aznn_curs1
               FETCH aznn_curs1 INTO g_plant_1[l_ac].yy,g_plant_1[l_ac].mm 
               IF STATUS THEN
                  CALL cl_err(g_plant_1[l_ac].gl_date,'anm-946',1)
                  NEXT FIELD p_bookno1
               END IF 
            END IF
            #No.FUN-680088 --end--
         END IF
            
         ON ACTION CONTROLP
           CASE
              WHEN INFIELD(gl_no) 
                    #CALL q_m_aac(FALSE,TRUE,g_plant_1[l_ac].gl_dbs,g_plant_1[l_ac].gl_no,'1',' ',' ','AGL') #No.FUN-840125
                 #  CALL q_m_aac(FALSE,TRUE,g_plant_1[l_ac].gl_dbs,g_plant_1[l_ac].gl_no,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                    CALL q_m_aac(FALSE,TRUE,g_plant_1[l_ac].p_plant,g_plant_1[l_ac].gl_no,'1','0',' ','AGL')  #No.FUN-840125   #No.FUN-980059
                         RETURNING g_plant_1[l_ac].gl_no
                    DISPLAY BY NAME g_plant_1[l_ac].gl_no
                    NEXT FIELD gl_no
              #No.FUN-680088 --start--
              WHEN INFIELD(gl_no1) 
                    #CALL q_m_aac(FALSE,TRUE,g_plant_1[l_ac].gl_dbs,g_plant_1[l_ac].gl_no1,'1',' ',' ','AGL') #No.FUN-840125
                #   CALL q_m_aac(FALSE,TRUE,g_plant_1[l_ac].gl_dbs,g_plant_1[l_ac].gl_no1,'1','0',' ','AGL') #No.FUN-840125    #No.FUN-980059
                    CALL q_m_aac(FALSE,TRUE,g_plant_1[l_ac].p_plant,g_plant_1[l_ac].gl_no1,'1','0',' ','AGL') #No.FUN-840125   #No.FUN-980059
                         RETURNING g_plant_1[l_ac].gl_no1
                    DISPLAY BY NAME g_plant_1[l_ac].gl_no1
                    NEXT FIELD gl_no1
              #No.FUN-680088 --end--
              #MOD-640339--------add-------------
              WHEN INFIELD(p_bookno) #帳別
                    SELECT azp03 INTO l_azp03  
                      FROM azp_file
                     WHERE azp01 = g_plant_1[l_ac].p_plant
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_m_aaa"
                    LET g_qryparam.default1 = g_plant_1[l_ac].p_bookno
#                   LET g_qryparam.arg1 = l_azp03                   #No.FUN-980025 mark
                    LET g_qryparam.plant = g_plant_1[l_ac].p_plant  #No.FUN-980025 add
                    CALL cl_create_qry() RETURNING g_plant_1[l_ac].p_bookno
                    DISPLAY BY NAME g_plant_1[l_ac].p_bookno
                    NEXT FIELD p_bookno
              #MOD-640339--------end-------------
              #No.FUN-680088 --start--
              WHEN INFIELD(p_bookno1)
                    SELECT azp03 INTO l_azp03_1
                      FROM azp_file
                     WHERE azp01 = g_plant_1[l_ac].p_plant
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_m_aaa"
                    LET g_qryparam.default1 = g_plant_1[l_ac].p_bookno1
#                   LET g_qryparam.arg1 = l_azp03_1                 #No.FUN-980025 mark
                    LET g_qryparam.plant = g_plant_1[l_ac].p_plant  #No.FUN-980025 add
                    CALL cl_create_qry() RETURNING g_plant_1[l_ac].p_bookno1
                    DISPLAY BY NAME g_plant_1[l_ac].p_bookno1
                    NEXT FIELD p_bookno1
              #No.FUN-680088 --end--
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
          
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
        
        ON ACTION help          
           CALL cl_show_help()  
 
      AFTER INPUT  #
         IF INT_FLAG THEN EXIT INPUT  END IF
         #所有plant的拋轉資料應填OK
         LET g_flag='N'
         FOR g_i = 1 TO g_rec_b
              IF cl_null(g_plant_1[g_i].p_plant)  OR
                 cl_null(g_plant_1[g_i].gl_dbs)   OR
                 cl_null(g_plant_1[g_i].p_bookno) OR
                 cl_null(g_plant_1[g_i].gl_no)    OR
                 cl_null(g_plant_1[g_i].gl_date)  OR
                 cl_null(g_plant_1[g_i].yy)       OR
                 cl_null(g_plant_1[g_i].mm)       THEN
                  #拋轉營運中心的相關欄位不可空白!
                  CALL cl_err(g_plant_1[g_i].p_plant,'anm-925',1)
                  LET g_flag='Y'
                  EXIT FOR
              END IF
              #No.FUN-680088 --start--
              IF g_aza.aza63 = 'Y' THEN
                 IF cl_null(g_plant_1[g_i].p_bookno1) OR
                    cl_null(g_plant_1[g_i].gl_no1) THEN
                    CALL cl_err(g_plant_1[g_i].p_plant,'anm-925',1)
                    LET g_flag='Y'
                    EXIT FOR
                 END IF
              END IF
              #No.FUN-680088 --end--
         END FOR
         IF g_flag = 'Y' THEN
             NEXT FIELD p_bookno
         END IF
 
    END INPUT
 
END FUNCTION
 
FUNCTION p930_create_tmp()
 
   DROP TABLE p930_tmp;
 
   #No.TQC-9B0039  --Begin
   #SELECT 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx' order1, npp_file.*,npq_file.*,
   #       SPACE(40) remark
   #  FROM npp_file,npq_file
   # WHERE npp01 = npq01 AND npp01 = '@@@@'
   #  INTO TEMP p930_tmp
   SELECT chr30 order1, npp_file.*,npq_file.*,
          chr1000 remark
     FROM npp_file,npq_file,type_file
    WHERE npp01 = npq01 AND npp01 = '@@@@'
      AND 1=0
     INTO TEMP p930_tmp
   #No.TQC-9B0039  --End  
 
   IF SQLCA.SQLCODE THEN
      LET g_success='N'
#     CALL cl_err('create p930_tmp',SQLCA.SQLCODE,0)   #No.FUN-660148
      CALL cl_err3("ins","p930_tmp","","",SQLCA.sqlcode,"","create p930_tmp",0) #No.FUN-660148
   END IF
 
   DELETE FROM p930_tmp WHERE 1=1
 
END FUNCTION
 
FUNCTION p930_t(l_npptype)  #No.FUN-680088 add l_npptype
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_order	LIKE type_file.chr1000#No.FUN-680107 VARCHAR(52) #為什麼長度為(52),因為npp01(30)+nnv05(10)+nnv20(10)=50,再加上減號(-)二個,共52
   DEFINE l_cmd  	LIKE type_file.chr1000#No.FUN-680107 VARCHAR(30)
   DEFINE l_remark VARCHAR(200) #LIKE type_file.chr1000#No.FUN-680107 VARCHAR(150)  #No.7319
   DEFINE l_nnm01       LIKE nnm_file.nnm01   #No:9028
   DEFINE l_nnm02       LIKE nnm_file.nnm02   #No:9028
   DEFINE l_nnm03       LIKE nnm_file.nnm03   #No:9028
   DEFINE l_name	LIKE type_file.chr20  #No.FUN-680107 VARCHAR(20)
   DEFINE nm_date	LIKE type_file.dat    #No.FUN-680107 DATE
   DEFINE nm_glno	LIKE nnv_file.nnv34
   DEFINE nm_glno_in	LIKE nnv_file.nnv35
   DEFINE nm_conf	LIKE nnv_file.nnvconf #No.FUN-680107 VARCHAR(1)
   DEFINE nm_user	LIKE nnv_file.nnvuser #No.FUN-680107 VARCHAR(10)
   DEFINE l_plant_out   LIKE nnv_file.nnv05
   DEFINE l_plant_in    LIKE nnv_file.nnv20
   DEFINE l_flag        LIKE type_file.chr1   #No.FUN-680107 VARCHAR(1)
   DEFINE l_yy,l_mm     LIKE type_file.num5   #No.FUN-680107 SMALLINT
   DEFINE l_msg         LIKE type_file.chr1000#No.FUN-680107 VARCHAR(80)
   DEFINE l_npptype     LIKE npp_file.npptype #No.FUN-680088
   DEFINE g_cnt1        LIKE type_file.num10  #No.FUN-680088  #No.FUN-680107 INTEGER
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   DEFINE l_bookno      LIKE aba_file.aba00   #FUN-840211
   DEFINE l_bdate       LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_edate       LIKE type_file.dat    #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1   #CHI-9A0021 add
   DEFINE l_npp01       LIKE npp_file.npp01   #TQC-BA0149
   DEFINE l_yy1         LIKE type_file.num5   #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5   #CHI-CB0004
   
   IF l_npptype = '0' THEN  #No.FUN-680088
      LET gl_no_b=''
      LET gl_no_e=''
   #No.FUN-680088 --start--
   ELSE
      LET gl_no1_b=''
      LET gl_no1_e=''
   END IF
   #No.FUN-680088 --end--
 
   DELETE FROM p930_tmp;
 
   #No.FUN-680088 --start--
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         LET g_sql = "SELECT aznn02,aznn04 ",
                     #"  FROM ",g_plant_1[l_ac].gl_dbs,"aznn_file ",
                     "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aznn_file'), #FUN-A50102
                     " WHERE aznn00 = '",g_plant_1[l_ac].p_bookno,"'",
                     "   AND aznn01 = '",g_plant_1[l_ac].gl_date,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
         PREPARE p930_aznn_pre2 FROM g_sql
         DECLARE aznn_curs2 CURSOR FOR p930_aznn_pre2
         OPEN aznn_curs2
         FETCH aznn_curs2 INTO g_plant_1[l_ac].yy,g_plant_1[l_ac].mm
      ELSE
         LET g_sql = "SELECT aznn02,aznn04 ",
                     #"  FROM ",g_plant_1[l_ac].gl_dbs,"aznn_file ",
                     "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aznn_file'), #FUN-A50102
                     " WHERE aznn00 = '",g_plant_1[l_ac].p_bookno1,"'",
                     "   AND aznn01 = '",g_plant_1[l_ac].gl_date,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
         PREPARE p930_aznn_pre3 FROM g_sql
         DECLARE aznn_curs3 CURSOR FOR p930_aznn_pre3
         OPEN aznn_curs3
         FETCH aznn_curs3 INTO g_plant_1[l_ac].yy,g_plant_1[l_ac].mm
      END IF
   ELSE
      LET g_sql = "SELECT azn02,azn04 ",
                  #"  FROM ",g_plant_1[l_ac].gl_dbs,"azn_file ",
                  "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'azn_file'), #FUN-A50102
                  " WHERE azn01 = '",g_plant_1[l_ac].gl_date,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
      PREPARE p930_azn_pre1 FROM g_sql
      DECLARE azn_curs1 CURSOR FOR p930_azn_pre1
      OPEN azn_curs1
      FETCH azn_curs1 INTO g_plant_1[l_ac].yy,g_plant_1[l_ac].mm
   END IF
   #No.FUN-680088 --end--
 
  #當月起始日與截止日
   CALL s_azm(YEAR(g_plant_1[l_ac].gl_date),MONTH(g_plant_1[l_ac].gl_date)) 
             RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
   #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
             #"  FROM ",g_plant_1[l_ac].gl_dbs,"npp_file,","nmy_file",
             "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'npp_file')," ,nmy_file", #FUN-A50102             
             " WHERE nppsys= 'NM'  ",
             "   AND (nppglno IS NULL OR nppglno = ' ' )",
             "   AND ",g_wc CLIPPED,
            #"   AND npp01[1,3]=nmyslip ",
             "   AND npp01 like ltrim(rtrim(nmyslip)) || '-%' ",
             "   AND nmydmy3='Y'",
            #CHI-9A0021 -- begin
            #"   AND ( YEAR(npp02)  !=YEAR('",g_plant_1[l_ac].gl_date,"') OR ",
            #"        (YEAR(npp02)   =YEAR('",g_plant_1[l_ac].gl_date,"') AND ",
            #"         MONTH(npp02) !=MONTH('",g_plant_1[l_ac].gl_date,"'))) ",
             "   AND npp02 NOT BETWEEN '",l_bdate,"' AND '",l_edate,"'",
            #CHI-9A0021 -- end
             "   AND npptype = '",l_npptype,"'",  #No.FUN-680088
             "   AND npp00 = ",g_npp00
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
   PREPARE p930_prechk FROM g_sql
   IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#      CALL cl_err('p930_prechk',STATUS,1)  
      CALL s_errmsg('','','p930_prechk',STATUS,1)
#No.FUN-710024--end
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE p930_chkdate CURSOR WITH HOLD FOR p930_prechk
   IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#      CALL cl_err('declare p930_chkdate',STATUS,1)
       CALL s_errmsg('','','declare p930_chkdate',STATUS,1)
#No.FUN-710024--end
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_flag='N'
   FOREACH p930_chkdate INTO l_yy,l_mm
      LET l_flag='Y'
      EXIT FOREACH
   END FOREACH
 
   IF l_flag ='Y' THEN
#No.FUN-710024--begin
#      CALL cl_err('err:','axr-061',1)
      CALL s_errmsg('','','err:','axr-061',1) 
#No.FUN-710024--end
      LET g_success = 'N'
      RETURN
   END IF
 
 
  #No.FUN-840211---Begin
  IF g_aaz.aaz81 = 'Y' THEN
     LET l_yy1 = YEAR(g_plant_1[l_ac].gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(g_plant_1[l_ac].gl_date)   #CHI-CB0004
     IF g_aza.aza63 = 'Y' THEN 
        IF l_npptype = '0' THEN
           #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_plant_1[l_ac].gl_dbs,"aba_file",
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                       " WHERE aba00 =  '",g_plant_1[l_ac].p_bookno,"'"
                      ,"   AND aba19 <> 'X' "  #CHI-C80041
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
        ELSE
           #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_plant_1[l_ac].gl_dbs,"aba_file",
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                       " WHERE aba00 =  '",g_plant_1[l_ac].p_bookno1,"'"
                      ,"   AND aba19 <> 'X' "  #CHI-C80041
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
        END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
        PREPARE aba11_pre FROM g_sql
        EXECUTE aba11_pre INTO l_aba11
     ELSE
      	#LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_plant_1[l_ac].gl_dbs,"aba_file",
        LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                       " WHERE aba00 =  '",g_plant_1[l_ac].p_bookno,"'"
                      ,"   AND aba19 <> 'X' "  #CHI-C80041
                      ,"   AND YEAR(aba02) = '",l_yy1,"' AND MONTH(aba02) = '",l_mm1,"'"  #CHI-CB0004
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
        PREPARE aba11_pre1 FROM g_sql
        EXECUTE aba11_pre1 INTO l_aba11
     END IF
    #CHI-CB0004--(B)
     IF cl_null(l_aba11) OR l_aba11 = 1 THEN
        LET l_aba11 = YEAR(g_plant_1[l_ac].gl_date)*1000000+MONTH(g_plant_1[l_ac].gl_date)*10000+1
     END IF
    #CHI-CB0004--(E)
    #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
     LET g_aba.aba11 = l_aba11
   ELSE 
      LET g_aba.aba11 = ' '        
     
  END IF      
  #No.FUN-840211---End
  
   #(是否自動傳票確認)
   #LET g_sql = "SELECT aaz85 FROM ",g_plant_1[l_ac].gl_dbs,"aaz_file",
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aaz_file'), #FUN-A50102
               " WHERE aaz00 = '0' "
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
 
   OPEN aaz85_cs 
   IF STATUS THEN
#No.FUN-710024--begin
#      CALL cl_err('open aaz85_cs',STATUS,1)
      CALL s_errmsg('','','open aaz85_cs',STATUS,1) 
#No.FUN-710024--end
      LET g_success = 'N'
      RETURN
   END IF
 
   FETCH aaz85_cs INTO g_aaz85
   IF STATUS THEN 
#No.FUN-710024--begin
#      CALL cl_err('fetch aaz85',STATUS,1)
      CALL s_errmsg('','','fetch aaz85',STATUS,1) 
#No.FUN-710024--end
      LET g_success = 'N'
      RETURN
   END IF
   #(end)
 
#  LET g_sql="SELECT npp_file.*,npq_file.* ",  #No.FUN-680088 mark
   #LET g_sql="SELECT ",g_plant_1[l_ac].gl_dbs,"npp_file.*,",g_plant_1[l_ac].gl_dbs,"npq_file.* ",  #No.FUN-680088
   #          "  FROM ",g_plant_1[l_ac].gl_dbs,"npp_file,",g_plant_1[l_ac].gl_dbs,"npq_file,","nmy_file",
   LET g_sql="SELECT ",cl_get_target_table(g_plant_1[l_ac].p_plant,'npp_file'),".*,", #FUN-A50102
                       cl_get_target_table(g_plant_1[l_ac].p_plant,'npq_file'),".*", #FUN-A50102
             "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'npp_file'),",",          #FUN-A50102
                       cl_get_target_table(g_plant_1[l_ac].p_plant,'npq_file')," ,nmy_file", #FUN-A50102
             " WHERE nppsys= 'NM'  ",
             "   AND (nppglno IS NULL OR nppglno = ' ' )",
             "   AND nppsys= npqsys AND npp00=npq00",
             "   AND npp01 = npq01 AND npp011=npq011",
             "   AND ",g_wc CLIPPED,
            #"   AND npp01[1,3]=nmyslip",
             "   AND npp01 like ltrim(rtrim(nmyslip)) || '-%' ",
             "   AND nmydmy3='Y'",
             "   AND npptype ='",l_npptype,"'",   #No.FUN-680088
             "   AND npqtype = npptype ",         #No.FUN-680088
             "   AND npp00 = ",g_npp00
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
   PREPARE p930_1_p0 FROM g_sql
   IF STATUS THEN 
#No.FUN-710024--begin
#       CALL cl_err('p930_1_p0',STATUS,1) 
       CALL s_errmsg('','','p930_1_p0',STATUS,1) 
#No.FUN-710024--end
       CALL cl_batch_bg_javamail("N")     
       LET g_success = 'N'
       RETURN
   END IF
   DECLARE p930_1_c0 CURSOR WITH HOLD FOR p930_1_p0
 
   CALL cl_outnam('anmp930') RETURNING l_name
   IF l_npptype = '0' THEN  #No.FUN-680088
      START REPORT anmp930_rep TO l_name
   #No.FUN-680088 --start--
   ELSE
      START REPORT anmp930_1_rep TO l_name
   END IF
   #No.FUN-680088 --end--
   LET g_success = 'Y'
   LET g_cnt1 = 0  #No.FUN-680088
 
   WHILE TRUE
      FOREACH p930_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err('foreach:',STATUS,1)
            CALL s_errmsg('','','foreach:',STATUS,1)
            LET g_success = 'N' EXIT FOREACH
         END IF
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF             
#No.FUN-710024--end        
         CASE 
             WHEN l_npp.nppsys='NM' AND l_npp.npp00=21      #集團資金調撥 
                  LET g_sql = "SELECT nnv02,nnv05,nnv20,nnv34,nnv35,nnvconf,nnvuser ",
                              "  FROM nnv_file",
                              " WHERE nnv01='",l_npp.npp01,"'"
                  PREPARE p930_21_pre FROM g_sql
                  DECLARE p930_21_cus CURSOR FOR p930_21_pre
                  OPEN p930_21_cus
                  FETCH p930_21_cus INTO nm_date,l_plant_out,l_plant_in,nm_glno,nm_glno_in,nm_conf,nm_user
                  IF STATUS THEN
#No.FUN-710024--begin
#                      CALL cl_err('sel nnv:',STATUS,1) 
                      CALL s_errmsg('nnv01',l_npp.npp01,'sel nnv:',STATUS,1)
#No.FUN-710024--end        
                      LET g_success='N'
                  END IF
             WHEN l_npp.nppsys='NM' AND l_npp.npp00=22      #集團資金還本
                  LET g_sql = "SELECT nnw02,nnw05,nnw20,nnw28,nnw29,nnwconf,nnwuser ",
                              "  FROM nnw_file",
                              " WHERE nnw01='",l_npp.npp01,"'",
                              "   AND nnw00 = '1' "
                  PREPARE p930_22_pre FROM g_sql
                  DECLARE p930_22_cus CURSOR FOR p930_22_pre
                  OPEN p930_22_cus
                  FETCH p930_22_cus INTO nm_date,l_plant_out,l_plant_in,nm_glno,nm_glno_in,nm_conf,nm_user
                  IF STATUS THEN
#No.FUN-710024--begin
#                      CALL cl_err('sel nnw:',STATUS,1) 
                      CALL s_errmsg('nnw01',l_npp.npp01,'sel nnw:',STATUS,1)
#No.FUN-710024--end        
                      LET g_success='N'
                  END IF
             WHEN l_npp.nppsys='NM' AND l_npp.npp00=23      #集團資金還息
                  LET g_sql = "SELECT nnw02,nnw05,nnw20,nnw28,nnw29,nnwconf,nnwuser ",
                              "  FROM nnw_file",
                              " WHERE nnw01='",l_npp.npp01,"'",
                              "   AND nnw00 = '2' "
                  PREPARE p930_23_pre FROM g_sql
                  DECLARE p930_23_cus CURSOR FOR p930_23_pre
                  OPEN p930_23_cus
                  FETCH p930_23_cus INTO nm_date,l_plant_out,l_plant_in,nm_glno,nm_glno_in,nm_conf,nm_user
                  IF STATUS THEN
#No.FUN-710024--begin
#                      CALL cl_err('sel nnw:',STATUS,1) 
                      CALL s_errmsg('nnw01',l_npp.npp01,'sel nnw:',STATUS,1)
#No.FUN-710024--end        
                      LET g_success='N'
                  END IF
              OTHERWISE CONTINUE FOREACH
         END CASE
         IF nm_conf='N' THEN CONTINUE FOREACH END IF
         IF nm_conf='X' THEN CONTINUE FOREACH END IF #已作廢 01/08/16
         IF nm_user<b_user OR nm_user>e_user THEN CONTINUE FOREACH END IF
         IF l_npptype ='0' THEN  #No.FUN-680088
            IF NOT cl_null(nm_glno) AND (l_plant_out = g_plant_1[l_ac].p_plant) THEN CONTINUE FOREACH END IF   #撥出傳票
         END IF  #No.FUN-680088
         IF l_npptype ='0' THEN  #No.FUN-680088
            IF NOT cl_null(nm_glno_in) AND (l_plant_in = g_plant_1[l_ac].p_plant) THEN CONTINUE FOREACH END IF #撥入傳票
         END IF  #No.FUN-680088
         IF l_npp.npp011=9 AND nm_date<>l_npp.npp02 THEN
            #no.7247
            LET l_msg= "Date differ:",nm_date,'-',l_npp.npp02,
                       "  * Press any key to continue ..."
            CALL cl_msgany(19,4,l_msg)
            LET INT_FLAG = 0  
         END IF
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         IF gl_tran = 'N' THEN 
              LET l_npq.npq04 = NULL 
              LET l_remark = l_npq.npq11 clipped,l_npq.npq12 clipped,
                             l_npq.npq13 clipped,l_npq.npq14 clipped,
                             #-----MOD-760129---------
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             #-----END MOD-760129-----
                             l_npq.npq15 clipped,l_npq.npq08 clipped
         ELSE LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                             l_npq.npq12 clipped,l_npq.npq13 clipped,
                             l_npq.npq14 clipped,
                             #-----MOD-760129---------
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             #-----END MOD-760129-----
                             l_npq.npq15 clipped,
                             l_npq.npq08 clipped
         END IF
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_npp.npp01 # 依單號
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 # 依日期
              OTHERWISE         LET l_order = ' '
         END CASE
         LET l_order = l_order CLIPPED,'-',l_plant_out CLIPPED,'-',l_plant_in 
         #02/02/19 bug no.4422 add
         #資料丟入temp file 排序
         INSERT INTO p930_tmp VALUES(l_order,l_npp.*,l_npq.*,l_remark)
         IF STATUS THEN
#            CALL cl_err('ins tmp:',STATUS,1)    #No.FUN-660148
#No.FUN-710024--begin
#             CALL cl_err3("ins","p930_tmp","","",STATUS,"","ins tmp:",1) #No.FUN-660148
             CALL s_errmsg('p930_tmp',l_order,'ins tmp:',STATUS,1)
#No.FUN-710024--end        
             LET g_success = 'N'
             EXIT FOREACH
         END IF
         LET g_cnt1 = g_cnt1 + 1        #No.FUN-680088
         #02/02/19 bug no.4422 add
      END FOREACH
#No.FUN-710024--begin
      IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
      END IF 
#No.FUN-710024--end  
 
      LET l_npp01 = NULL   #No.TQC-BA0149
      #-02/02/19 bug no.4422 add--
      DECLARE p930_tmpcs CURSOR FOR
         SELECT * FROM p930_tmp 
          ORDER BY order1,npp01,npq06,npq03,npq05,  #No.TQC-BA0149 add npp01
                   npq24,npq25,remark,npq01
      FOREACH p930_tmpcs INTO l_order,l_npp.*,l_npq.*,l_remark
         IF STATUS THEN
#No.FUN-710024--begin
#            CALL cl_err('for tmp:',STATUS,1)
            CALL s_errmsg('','','for tmp:',STATUS,1)
            LET g_success='N' EXIT FOREACH  
         END IF
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF             
#No.FUN-710024--end        
         #No.TQC-BA0149  --Begin
         IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
            LET l_npp.npp08 = 0
         END IF
         LET l_npp01 = l_npp.npp01
         #No.TQC-BA0149  --End
         IF l_npptype = '0' THEN  #No.FUN-680088
            OUTPUT TO REPORT anmp930_rep(l_order,l_npp.*,l_npq.*,l_remark)
         #No.FUN-680088 --start--
         ELSE
            OUTPUT TO REPORT anmp930_1_rep(l_order,l_npp.*,l_npq.*,l_remark)
         END IF
         #No.FUN-680088 --end--
      END FOREACH
#No.FUN-710024--begin
      IF g_totsuccess="N" THEN                                                                                                         
         LET g_success="N"                                                                                                             
      END IF 
#No.FUN-710024--end  
      EXIT WHILE
   END WHILE
   IF l_npptype = '0' THEN  #No.FUN-680088
      FINISH REPORT anmp930_rep
   #No.FUN-680088 --start--
   ELSE
      FINISH REPORT anmp930_1_rep
   END IF
   #No.FUN-680088 --end--
#  LET l_cmd = "chmod 777 ", l_name                   #No.FUN-9C0009
#  RUN l_cmd                                          #No.FUN-9C0009
   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
   #No.FUN-680029 --begin--
   IF g_cnt1 = 0  THEN
#No.FUN-710024--begin
#      CALL cl_err('','aap-129',1)
      CALL s_errmsg('','','','aap-129',1) 
#No.FUN-710024--end  
      LET g_success = 'N'
   END IF
   #No.FUN-680029 --end--
END FUNCTION
 
REPORT anmp930_rep(l_order,l_npp,l_npq,l_remark)
  DEFINE l_order	LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(52)  
  DEFINE l_npk		RECORD LIKE npk_file.*
  DEFINE l_nnm01        LIKE nnm_file.nnm01     #No:9028
  DEFINE l_nnm02        LIKE nnm_file.nnm02     #No.MOD-560179
  DEFINE l_nnm03        LIKE nnm_file.nnm03     #No.MOD-560179
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5     #No.FUN-680107 SMALLINT # 傳票項次
  DEFINE l_nmg01        LIKE   nmg_file.nmg01
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6  #No.FUN-680107 DECIMAL(20,6)   #No.FUN-4C0010
  DEFINE l_remark       VARCHAR(200)               #LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(150)  #No.7319
  DEFINE li_result      LIKE type_file.num5     #No.FUN-560190  #No.FUN-680107 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01  
  DEFINE l_flag1        LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
  DEFINE l_nnv05        LIKE nnv_file.nnv05
  DEFINE l_nnv20        LIKE nnv_file.nnv20
  DEFINE l_nnw05        LIKE nnw_file.nnw05
  DEFINE l_nnw20        LIKE nnw_file.nnw20
  DEFINE l_legal        LIKE aba_file.abalegal  #FUN-980005 
  DEFINE l_order_1      LIKE type_file.chr1000  #TQC-9C0179
  DEFINE l_npp08        LIKE npp_file.npp08     #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021 
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_npq.npq08,
           l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
   #缺號使用               
   LET l_flag1='N'         
   LET l_missingno = NULL 
   LET g_j=g_j+1         
   SELECT tc_tmp02 
     INTO l_missingno    
     FROM agl_tmp_file                 
    WHERE tc_tmp01=g_j 
      AND tc_tmp00 = 'Y'     
      AND tc_tmp03 = g_plant_1[l_ac].p_bookno  #No.FUN-680088
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                       
      LET g_plant_1[l_ac].gl_no=l_missingno                
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = g_plant_1[l_ac].gl_no     
                                AND tc_tmp03 = g_plant_1[l_ac].p_bookno  #No.FUN-680088
   END IF                                               
                                                       
   #缺號使用完，再在流水號最大的編號上增加            
   IF l_flag1='N' THEN                               
     #No.FUN-CB0096 ---start--- Add
      LET t_no = Null
      CALL s_log_check(l_order_1) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET g_plant_1[l_ac].gl_no = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---end  --- Add
    #CALL s_auto_assign_no("agl",g_plant_1[l_ac].gl_no,g_plant_1[l_ac].gl_date,"","","",g_plant_1[l_ac].gl_dbs,"",g_plant_1[l_ac].p_bookno) #FUN-980094 mark
     CALL s_auto_assign_no("agl",g_plant_1[l_ac].gl_no,g_plant_1[l_ac].gl_date,"","","",g_plant_1[l_ac].p_plant,"",g_plant_1[l_ac].p_bookno) #FUN-980094
          RETURNING li_result,g_plant_1[l_ac].gl_no
      END IF   #No.FUN-CB0096   Add
     PRINT "Get max TR-no:",g_plant_1[l_ac].gl_no," Return code(li_result):",li_result                                                                    
     IF li_result = 0 THEN LET g_success = 'N' END IF      
    #DISPLAY "Insert G/L voucher no:",g_plant_1[l_ac].gl_no AT 1,1  #CHI-9A0021
     PRINT "Insert aba:",g_plant_1[l_ac].p_bookno,' ',g_plant_1[l_ac].gl_no,' From:',l_order
   END IF  
     #LET g_sql="INSERT INTO ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                       "(aba00,aba01,aba02,aba03,aba04,",
                       " aba05,aba06,aba07,aba08,aba09,",
                       " aba12,aba19,aba20,abamksg,abasign,",
                       " abadays,abaprit,abasmax,abasseq,abaprno,",
                       " abapost,abaacti,abauser,abagrup,abamodu,",
                       " abadate,aba24,aba11,",     #FUN-840211 add aba11
                       " abalegal,abaoriu,abaorig,aba21) ",   #FUN-980005 #TQC-A10060 add abaoriu,abaorig FUN-A10006
                       " VALUES (?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,?,?)"             #FUN-840211 add ?  #TQC-A10060 add ?,? FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p930_1_p4 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=g_plant_1[l_ac].gl_no
     LET g_aba01t = s_get_doc_no(g_plant_1[l_ac].gl_no)
     #簽核處理 (Y/N)
     LET g_sql = "SELECT aac08,aacatsg,aacdays,aacprit,aacsign ",
                 #"  FROM ",g_plant_1[l_ac].gl_dbs,"aac_file",
                 "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aac_file'), #FUN-A50102
                 " WHERE aac01 = '",g_aba01t,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p930_aac_pre FROM g_sql
     DECLARE p930_aac_cus CURSOR FOR p930_aac_pre
     OPEN p930_aac_cus
     FETCH p930_aac_cus INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,g_aba.abaprit,g_aba.abasign
     IF STATUS THEN
#No.FUN-710024--begin 
#         CALL cl_err('sel aac:',STATUS,1) 
        CALL s_errmsg('','','sel aac:',STATUS,1)
#No.FUN-710024--end 
         LET g_success='N'
     END IF
     IF g_aba.abamksg MATCHES  '[Yy]' THEN
        IF g_aac.aacatsg matches'[Yy]' THEN   #自動付予
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        LET g_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_plant_1[l_ac].gl_dbs,"azc_file",
                    "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'azc_file'), #FUN-A50102
                    " WHERE azc01= '",g_aba.abasign,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
        PREPARE p930_azc_pre FROM g_sql
        DECLARE p930_azc_cus CURSOR FOR p930_azc_pre
        OPEN p930_azc_cus
        FETCH p930_azc_cus INTO g_aba.abasmax
     END IF
## ----
     LET g_system = 'NM'
     LET g_zero   = 0
     LET g_zero1  = '0'
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     #FUN-980005 add legal 
     CALL s_getlegal(g_plant_1[l_ac].p_plant) RETURNING l_legal  
     LET g_aba.abalegal = l_legal 
     #FUN-980005 end legal
    
     LET g_aba.abaoriu = g_user   #TQC-A10060 add
     LET g_aba.abaorig = g_grup   #TQC-A10060 add
     LET l_order_1 = l_order[1,30] CLIPPED             #TQC-9C0179 
     EXECUTE p930_1_p4 USING g_plant_1[l_ac].p_bookno, #aba00
                             g_plant_1[l_ac].gl_no,    #aba01
                             g_plant_1[l_ac].gl_date,  #aba02
                             g_plant_1[l_ac].yy,       #aba03
                             g_plant_1[l_ac].mm,       #aba04
                             g_today,                #aba05
                             g_system,               #aba06
                             #l_order[1,30],         #aba07  #FUN-710020 #TQC-9C0179 mark
                             l_order_1,              #aba07  #TQC-9C0179 
                             g_zero,                 #aba08
                             g_zero,                 #aba09
                             g_N,                    #aba12
                             g_N,                    #aba19
                             g_zero1,                #aba20
                             g_aba.abamksg,          #abamksg
                             g_aba.abasign,          #abasign
                             g_aba.abadays,          #abadays
                             g_aba.abaprit,          #abaprit
                             g_aba.abasmax,          #abasmax
                             g_zero,                 #abasseq
                             g_zero,                 #abaprno
                             g_N,                    #abapost
                             g_Y,                    #abaacti
                             g_user,                 #abauser
                             g_grup,                 #abagrup
                             g_user,                 #abamodu
                             g_today,                #abadate
                             g_user                  #aba24
                             ,g_aba.aba11   #FUN-840211 add aba11
                            ,g_aba.abalegal          #FUN-980005
                            ,g_aba.abaoriu           #TQC-A10060 add
                            ,g_aba.abaorig           #TQC-A10060 add    
                            ,l_npp.npp08             #FUN-A10006 add npp08
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
        CALL s_errmsg('','','ins aba:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
#     LET g_sql = "DELETE FROM",g_plant_1[l_ac].gl_dbs,"tmn_file",    #TQC-960310   
     #LET g_sql = "DELETE FROM ",g_plant_1[l_ac].gl_dbs,"tmn_file",  #TQC-960310
     LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'tmn_file'), #FUN-A50102   
                 " WHERE tmn01 = '",g_plant_1[l_ac].p_plant,"'",
                 "   AND tmn02 = '",g_plant_1[l_ac].gl_no,"'",
                 "   AND tmn06 = '",g_plant_1[l_ac].p_bookno,"'"  #No.FUN-680088          
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p930_del_tmn2 FROM g_sql
     EXECUTE p930_del_tmn2
     IF gl_no_b IS NULL THEN LET gl_no_b = g_plant_1[l_ac].gl_no END IF
     LET gl_no_e = g_plant_1[l_ac].gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     CASE 
          WHEN l_npp.nppsys='NM' AND l_npp.npp00=21  
               #==>更新調撥資料
               SELECT nnv05,nnv20 
                 INTO l_nnv05,l_nnv20
                 FROM nnv_file
                WHERE nnv01 = l_npq.npq01
               IF l_nnv05 = g_plant_1[l_ac].p_plant THEN
                   UPDATE nnv_file 
                      SET nnv34 = g_plant_1[l_ac].gl_no #撥出傳票號碼
                    WHERE nnv01 = l_npq.npq01
                      AND nnv05 = g_plant_1[l_ac].p_plant
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                     CALL cl_err('up nnv_file',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                      CALL cl_err3("upd","nnv_file",l_npq.npq01,g_plant_1[l_ac].p_plant,SQLCA.sqlcode,"","up nnv_file",1) #No.FUN-660148
                     LET g_showmsg=l_npq.npq01,"/",g_plant_1[l_ac].p_plant
                     CALL s_errmsg('nnv01,nnv05',g_showmsg,'upd nnv_file',SQLCA.sqlcode,1)
#No.FUN-710024--end
                      LET g_success = 'N'
                   END IF
               END IF
               IF l_nnv20 = g_plant_1[l_ac].p_plant THEN
                   UPDATE nnv_file 
                      SET nnv35 = g_plant_1[l_ac].gl_no #撥入傳票號碼
                    WHERE nnv01 = l_npq.npq01
                      AND nnv20 = g_plant_1[l_ac].p_plant
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                     CALL cl_err('up nnv_file',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                      CALL cl_err3("upd","nnv_file",l_npq.npq01,g_plant_1[l_ac].p_plant,SQLCA.sqlcode,"","up nnv_file",1) #No.FUN-660148
                     LET g_showmsg=l_npq.npq01,"/",g_plant_1[l_ac].p_plant
                     CALL s_errmsg('nnv01,nnv20',g_showmsg,'upd nnv_file',SQLCA.sqlcode,1)
#No.FUN-710024--end
                      LET g_success = 'N'
                   END IF
               END IF
          WHEN l_npp.nppsys='NM' AND l_npp.npp00=22  #還本
               #==>更新還本資料
               SELECT nnw05,nnw20 
                 INTO l_nnw05,l_nnw20
                 FROM nnw_file
                WHERE nnw01 = l_npq.npq01
                  AND nnw00 = '1'
               IF l_nnw05 = g_plant_1[l_ac].p_plant THEN
                   UPDATE nnw_file 
                      SET nnw28 = g_plant_1[l_ac].gl_no
                    WHERE nnw01 = l_npq.npq01
                      AND nnw05 = g_plant_1[l_ac].p_plant
                      AND nnw00 = '1'
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                     CALL cl_err('up nnw_file',SQLCA.sqlcode,1)   #No.FUN-660148
#No.FUN-710024--begin
#                      CALL cl_err3("upd","nnw_file",l_npq.npq01,g_plant_1[l_ac].p_plant,SQLCA.sqlcode,"","up nnw_file",1) #No.FUN-660148
                     LET g_showmsg=l_npq.npq01,"/",g_plant_1[l_ac].p_plant
                     CALL s_errmsg('nnw01,nnw05',g_showmsg,'upd nnw_file',SQLCA.sqlcode,1)
#No.FUN-710024--end
                      LET g_success = 'N'
                   END IF
               END IF
               IF l_nnw20 = g_plant_1[l_ac].p_plant THEN
                   UPDATE nnw_file 
                      SET nnw29 = g_plant_1[l_ac].gl_no
                    WHERE nnw01 = l_npq.npq01
                      AND nnw20 = g_plant_1[l_ac].p_plant
                      AND nnw00 = '1'
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                     CALL cl_err('up nnw_file',SQLCA.sqlcode,1)   #No.FUN-660148
                      CALL cl_err3("upd","nnw_file",l_npq.npq01,g_plant_1[l_ac].p_plant,SQLCA.sqlcode,"","up nnw_file",1) #No.FUN-660148
                      LET g_success = 'N'
                   END IF
               END IF
          WHEN l_npp.nppsys='NM' AND l_npp.npp00=23  #還息
               #==>更新還本資料
               SELECT nnw05,nnw20 
                 INTO l_nnw05,l_nnw20
                 FROM nnw_file
                WHERE nnw01 = l_npq.npq01
                  AND nnw00 = '2'
               IF l_nnw05 = g_plant_1[l_ac].p_plant THEN
                   UPDATE nnw_file 
                      SET nnw28 = g_plant_1[l_ac].gl_no
                    WHERE nnw01 = l_npq.npq01
                      AND nnw05 = g_plant_1[l_ac].p_plant
                      AND nnw00 = '2'
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                     CALL cl_err('up nnw_file',SQLCA.sqlcode,1)   #No.FUN-660148
                      CALL cl_err3("upd","nnw_file",l_npq.npq01,g_plant_1[l_ac].p_plant,SQLCA.sqlcode,"","up nnw_file",1) #No.FUN-660148
                      LET g_success = 'N'
                   END IF
               END IF
               IF l_nnw20 = g_plant_1[l_ac].p_plant THEN
                   UPDATE nnw_file 
                      SET nnw29 = g_plant_1[l_ac].gl_no
                    WHERE nnw01 = l_npq.npq01
                      AND nnw20 = g_plant_1[l_ac].p_plant
                      AND nnw00 = '2'
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] =0 THEN
#                     CALL cl_err('up nnw_file',SQLCA.sqlcode,1)   #No.FUN-660148
                      CALL cl_err3("upd","nnw_file",l_npq.npq01,g_plant_1[l_ac].p_plant,SQLCA.sqlcode,"","up nnw_file",1) #No.FUN-660148
                      LET g_success = 'N'
                   END IF
               END IF
     END CASE
     #==>更新銀行存款異動記錄檔
     #LET g_sql = " UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"nme_file",
     LET g_sql = " UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'nme_file'), #FUN-A50102 
                 "    SET nme10 = ? ,",
                 "        nme16 = ?  ", 
                 "  WHERE nme12 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE upd_nme FROM g_sql
     EXECUTE upd_nme USING g_plant_1[l_ac].gl_no,g_plant_1[l_ac].gl_date,l_npp.npp01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('upd nme:',SQLCA.sqlcode,1) 
         LET g_success = 'N'
     END IF
 
     #==>分錄底稿單頭檔
     #LET g_sql = " UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"npp_file",
     LET g_sql = " UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'npp_file'), #FUN-A50102
                 "    SET npp03   = ? ,",
                 "        nppglno = ? ,", 
                 "        npp06   = ? ,", 
                 "        npp07   = ?  ", 
                 " WHERE npp01 = ? ",
                 "   AND npp011= ? ",
                 "   AND npp00 = ? ",
                 "   AND nppsys= ? ",
                 "   AND npptype = '0'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE upd_npp FROM g_sql
     EXECUTE upd_npp USING g_plant_1[l_ac].gl_date,g_plant_1[l_ac].gl_no,g_plant_1[l_ac].p_plant,g_plant_1[l_ac].p_bookno,
                           l_npp.npp01,l_npp.npp011,l_npp.npp00,l_npp.nppsys
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err('upd npp:',SQLCA.sqlcode,1) 
         LET g_success = 'N'
     END IF
 
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
    #DISPLAY "Seq:",l_seq AT 2,1  #CHI-9A0021
     #LET g_sql = "INSERT INTO ",g_plant_1[l_ac].gl_dbs CLIPPED,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_1[l_ac].p_plant,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07, ",
                     #   " abb08,abb11,abb12,abb13,abb14,abb15, ",          #No.FUN-810069 
                        " abb08,abb11,abb12,abb13,abb14, ",                 #No.FUN-810069  
                        " abb24,abb25,",
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        ",abblegal",   #FUN-980005 
                        " )",
             #    " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",           #No.FUN-810069  
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?",              #No.FUN-810069  
                 "       ,?,?,?,?,?, ?,?,?)" 
     #-----No.FUN-640142-----
     SELECT azi04 INTO t_azi04 FROM azi_file    #NO.CHI-6A0004
      WHERE azi01 = l_npq.npq24
     #-----No.FUN-640142 END-----
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
     CALL cl_digcut(l_amtf,t_azi04) RETURNING l_amtf  #No.FUN-640142  #NO.CHI-6A0004
     CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt  #No.FUN-640142
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     #FUN-980005 add legal 
     CALL s_getlegal(g_plant_1[l_ac].p_plant) RETURNING l_legal  
     #FUN-980005 end legal 
     PREPARE p930_1_p5 FROM g_sql
     EXECUTE p930_1_p5 USING 
                g_plant_1[l_ac].p_bookno,g_plant_1[l_ac].gl_no,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
             #   l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25,           #No.FUN-810069  
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                        #No.FUN-810069  
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37
               ,l_legal 
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins abb:',SQLCA.sqlcode,1)  
         LET g_success = 'N'
     END IF
   
     IF l_npq.npq06 = '1' THEN
         LET l_debit  = l_debit  + l_amt
     ELSE 
         LET l_credit = l_credit + l_amt
     END IF
     CALL cl_digcut(l_debit,g_azi04) RETURNING l_debit  #No.FUN-640142
     CALL cl_digcut(l_credit,g_azi04) RETURNING l_credit  #No.FUN-640142
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
     #LET g_sql = "UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file SET (aba08,aba09) = (?,?)",
      #LET g_sql = "UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                  "   SET aba08 = ?,",
                  "       aba09 = ? ",
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? ",
                  "   AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
      PREPARE p930_1_p6 FROM g_sql
      EXECUTE p930_1_p6 USING l_debit,l_credit,l_npp08,g_plant_1[l_ac].gl_no,g_plant_1[l_ac].p_bookno #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) 
          LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',g_plant_1[l_ac].p_bookno,g_plant_1[l_ac].gl_no,g_plant_1[l_ac].gl_date,g_N,'',TRUE)   #No.TQC-B70021
IF g_aaz85 = 'Y' THEN 
      #若有立沖帳管理就不做自動確認
      #LET g_sql = "SELECT COUNT(*) FROM ",g_plant_1[l_ac].gl_dbs CLIPPED," abb_file,aag_file",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'abb_file')," ,aag_file", #FUN-A50102      
                  " WHERE abb01 = '",g_plant_1[l_ac].gl_no,"'",
                  "   AND abb00 = '",g_plant_1[l_ac].p_bookno,"'",
                  "   AND abb03 = aag01  ",
                  "   AND aag00 = abb00 AND aag00 = g_aza.aza81",       #NO.FUN-740049
                  "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
      PREPARE count_pre FROM g_sql
      DECLARE count_cs CURSOR FOR count_pre
      OPEN count_cs 
      FETCH count_cs INTO g_cnt
      CLOSE count_cs
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
        #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-850183 mark
        #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-850183 mark
         IF g_aba.abamksg='N' THEN                       #MOD-850183
            LET g_aba.aba20='1' 
         #END IF   #MOD-770101
            LET g_aba.aba19 = 'Y'
            #LET g_sql = " UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (g_plant_1[l_ac].p_bookno,g_plant_1[l_ac].gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end  
            LET g_sql = " UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                        "    SET abamksg = ? ,",
                               " abasign = ? ,", 
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",              #MOD-A80136 
                               " aba37   = ?  ",              #MOD-A80136
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
            PREPARE upd_aba19 FROM g_sql
            EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user,                    #MOD-A80136
#                                   g_plant_1[l_ac].gl_no,g_nmz.nmz02b              #No.FUN-680088  mark
                                    g_plant_1[l_ac].gl_no,g_plant_1[l_ac].p_bookno  #No.FUN-680088
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
                CALL cl_err('upd aba19',STATUS,1) 
                LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF     
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,g_plant_1[l_ac].gl_no,l_order_1)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
     #LET g_plant_1[l_ac].gl_no[4,16]=''
      LET g_plant_1[l_ac].gl_no=''
      LET g_plant_1[l_ac].gl_no=g_aba01t
END REPORT
 
#No.FUN-680088 --start--
REPORT anmp930_1_rep(l_order,l_npp,l_npq,l_remark)
  #DEFINE l_order	LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(52) #FUN-710020
  DEFINE l_order	LIKE aba_file.aba07                             #FUN-710020
  DEFINE l_npk		RECORD LIKE npk_file.*
  DEFINE l_nnm01        LIKE nnm_file.nnm01     #No:9028
  DEFINE l_nnm02        LIKE nnm_file.nnm02     #No.MOD-560179
  DEFINE l_nnm03        LIKE nnm_file.nnm03     #No.MOD-560179
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_seq		LIKE type_file.num5     #No.FUN-680107 SMALLINT # 傳票項次
  DEFINE l_nmg01        LIKE   nmg_file.nmg01
  DEFINE l_credit,l_debit,l_amt,l_amtf LIKE type_file.num20_6  #No.FUN-680107 DECIMAL(20,6) #No.FUN-4C0010
  DEFINE l_remark       VARCHAR(200)               #LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(150)  #No.7319
  DEFINE li_result      LIKE type_file.num5     #No.FUN-560190  #No.FUN-680107 SMALLINT
  DEFINE l_missingno    LIKE aba_file.aba01  
  DEFINE l_flag1        LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
  DEFINE l_nnv05        LIKE nnv_file.nnv05
  DEFINE l_nnv20        LIKE nnv_file.nnv20
  DEFINE l_nnw05        LIKE nnw_file.nnw05
  DEFINE l_nnw20        LIKE nnw_file.nnw20
  DEFINE l_legal        LIKE aba_file.abalegal  #FUN-980005 
  DEFINE l_order_1      LIKE aba_file.aba07     #TQC-9C0179
  DEFINE l_npp08        LIKE npp_file.npp08     #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021
   
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_order,l_npq.npq06,l_npq.npq03,l_npq.npq05,
           l_npq.npq24,l_npq.npq25,l_npq.npq08,
           l_remark,l_npq.npq01
  FORMAT
   #--------- Insert aba_file ---------------------------------------------
   BEFORE GROUP OF l_order
   #缺號使用               
   LET l_flag1='N'         
   LET l_missingno = NULL 
   LET g_j=g_j+1         
   SELECT tc_tmp02 
     INTO l_missingno    
     FROM agl_tmp_file                 
    WHERE tc_tmp01=g_j 
      AND tc_tmp00 = 'Y'     
      AND tc_tmp03 = g_plant_1[l_ac].p_bookno1
   IF NOT cl_null(l_missingno) THEN          
      LET l_flag1='Y'                       
      LET g_plant_1[l_ac].gl_no1=l_missingno                
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = g_plant_1[l_ac].gl_no1     
                                AND tc_tmp03 = g_plant_1[l_ac].p_bookno1
   END IF                                               
                                                       
   #缺號使用完，再在流水號最大的編號上增加            
   IF l_flag1='N' THEN                               
     #No.FUN-CB0096 ---start--- Add
      LET t_no = Null
      CALL s_log_check(l_order_1) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET g_plant_1[l_ac].gl_no1 = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---end  --- Add
    #CALL s_auto_assign_no("agl",g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].gl_date,"","","",g_plant_1[l_ac].gl_dbs,"",g_plant_1[l_ac].p_bookno1) #FUN-980094 mark
     CALL s_auto_assign_no("agl",g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].gl_date,"","","",g_plant_1[l_ac].p_plant,"",g_plant_1[l_ac].p_bookno1) #FUN-980094
          RETURNING li_result,g_plant_1[l_ac].gl_no1
      END IF  #No.FUN-CB0096   Add
     PRINT "Get max TR-no:",g_plant_1[l_ac].gl_no1," Return code(li_result):",li_result                                                                    
     IF li_result = 0 THEN LET g_success = 'N' END IF      
    #DISPLAY "Insert G/L voucher no:",g_plant_1[l_ac].gl_no1 AT 1,1  #CHI-9A0021
     PRINT "Insert aba:",g_plant_1[l_ac].p_bookno1,' ',g_plant_1[l_ac].gl_no1,' From:',l_order
   END IF  
     #LET g_sql="INSERT INTO ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file",
     LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                       "(aba00,aba01,aba02,aba03,aba04,",
                       " aba05,aba06,aba07,aba08,aba09,",
                       " aba12,aba19,aba20,abamksg,abasign,",
                       " abadays,abaprit,abasmax,abasseq,abaprno,",
                       " abapost,abaacti,abauser,abagrup,abamodu,",
                       " abadate,aba24,aba11,",     #FUN-840211 add aba11
                       " abalegal,abaoriu,abaorig,aba21)", #FUN-980005 #TQC-A10060 add abaoriu,abaorig FUN-A10006
                       " VALUES (?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,",
                       "        ?,?,?,?,?,?,?)"       #FUN-840211 add ?   #TQC-A10060 add ?,?   FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p930_1_p7 FROM g_sql
## ----
     #自動賦予簽核等級
     LET g_aba.aba01=g_plant_1[l_ac].gl_no1
     LET g_aba01t = s_get_doc_no(g_plant_1[l_ac].gl_no1)
     #簽核處理 (Y/N)
     LET g_sql = "SELECT aac08,aacatsg,aacdays,aacprit,aacsign ",
                 #"  FROM ",g_plant_1[l_ac].gl_dbs,"aac_file",
                 "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aac_file'), #FUN-A50102
                 " WHERE aac01 = '",g_aba01t,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p930_aac_pre1 FROM g_sql
     DECLARE p930_aac_cus1 CURSOR FOR p930_aac_pre1
     OPEN p930_aac_cus1
     FETCH p930_aac_cus1 INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,g_aba.abaprit,g_aba.abasign
     IF STATUS THEN
#No.FUN-710024--begin
#         CALL cl_err('sel aac:',STATUS,1) 
        CALL s_errmsg('','','sel aac:',STATUS,1)
#No.FUN-710024--end
         LET g_success='N'
     END IF
     IF g_aba.abamksg MATCHES  '[Yy]' THEN
        IF g_aac.aacatsg matches'[Yy]' THEN   #自動付予
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        LET g_sql = "SELECT COUNT(*) ",
                    #"  FROM ",g_plant_1[l_ac].gl_dbs,"azc_file",
                    "  FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'azc_file'), #FUN-A50102
                    " WHERE azc01= '",g_aba.abasign,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
        PREPARE p930_azc_pre1 FROM g_sql
        DECLARE p930_azc_cus1 CURSOR FOR p930_azc_pre1
        OPEN p930_azc_cus1
        FETCH p930_azc_cus1 INTO g_aba.abasmax
     END IF
## ----
     LET g_system = 'NM'
     LET g_zero   = 0
     LET g_zero1  = '0'
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     #FUN-980005 add legal 
     CALL s_getlegal(g_plant_1[l_ac].p_plant) RETURNING l_legal  
     LET g_aba.abalegal = l_legal 
     #FUN-980005 end legal
     LET g_aba.abaoriu = g_user      #TQC-A10060 add 
     LET g_aba.abaorig = g_grup      #TQC-A10060 add
     LET l_order_1 = l_order[1,30] CLIPPED              #TQC-9C0179 
     EXECUTE p930_1_p7 USING g_plant_1[l_ac].p_bookno1, #aba00
                             g_plant_1[l_ac].gl_no1,    #aba01
                             g_plant_1[l_ac].gl_date,  #aba02
                             g_plant_1[l_ac].yy,       #aba03
                             g_plant_1[l_ac].mm,       #aba04
                             g_today,                #aba05
                             g_system,               #aba06
                            #l_order[1,16],          #aba07  #FUN-710020
                            #l_order[1,30],          #aba07  #FUN-710020 #TQC-9C0179 mark
                             l_order_1,              #aba07  #TQC-9C0179 
                             g_zero,                 #aba08
                             g_zero,                 #aba09
                             g_N,                    #aba12
                             g_N,                    #aba19
                             g_zero1,                #aba20
                             g_aba.abamksg,          #abamksg
                             g_aba.abasign,          #abasign
                             g_aba.abadays,          #abadays
                             g_aba.abaprit,          #abaprit
                             g_aba.abasmax,          #abasmax
                             g_zero,                 #abasseq
                             g_zero,                 #abaprno
                             g_N,                    #abapost
                             g_Y,                    #abaacti
                             g_user,                 #abauser
                             g_grup,                 #abagrup
                             g_user,                 #abamodu
                             g_today,                #abadate
                             g_user                  #aba24
                             ,g_aba.aba11   #FUN-840211 add aba11
                            ,g_aba.abalegal  #FUN-980005 
                            ,g_aba.abaoriu   #TQC-A10060 add
                            ,g_aba.abaorig   #TQC-A10060 add
                            ,l_npp.npp08     #FUN-A10006 add npp08
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
        CALL s_errmsg('azc01',g_aba.abasign,'sel azc_file:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
#     LET g_sql = "DELETE FROM",g_plant_1[l_ac].gl_dbs,"tmn_file",  #TQC-960310  
     #LET g_sql = "DELETE FROM ",g_plant_1[l_ac].gl_dbs,"tmn_file",   #TQC-960310
    LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'tmn_file'), #FUN-A50102
                 " WHERE tmn01 = '",g_plant_1[l_ac].p_plant,"'",
                 "   AND tmn02 = '",g_plant_1[l_ac].gl_no1,"'",
                 "   AND tmn06 = '",g_plant_1[l_ac].p_bookno1,"'"  #No.FUN-680088
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE p930_del_tmn2_1 FROM g_sql
     EXECUTE p930_del_tmn2_1
     IF gl_no1_b IS NULL THEN LET gl_no1_b = g_plant_1[l_ac].gl_no1 END IF
     LET gl_no1_e = g_plant_1[l_ac].gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   #------------------ Update gl-no To original file --------------------------
   AFTER GROUP OF l_npq.npq01
     #==>更新銀行存款異動記錄檔
     #LET g_sql = " UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"nme_file",
     LET g_sql = " UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'nme_file'), #FUN-A50102
                 "    SET nme10 = ? ,",
                 "        nme16 = ?  ", 
                 "  WHERE nme12 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE upd_nme1 FROM g_sql
     EXECUTE upd_nme1 USING g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].gl_date,l_npp.npp01
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#No.FUN-710024--begin
#         CALL cl_err('upd nme:',SQLCA.sqlcode,1) 
        CALL s_errmsg('nme12',l_npp.npp01,'upd nme:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
 
     #==>分錄底稿單頭檔
     #LET g_sql = " UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"npp_file",
     LET g_sql = " UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'npp_file'), #FUN-A50102
                 "    SET npp03   = ? ,",
                 "        nppglno = ? ,", 
                 "        npp06   = ? ,", 
                 "        npp07   = ?  ", 
                 " WHERE npp01 = ? ",
                 "   AND npp011= ? ",
                 "   AND npp00 = ? ",
                 "   AND nppsys= ? ",
                 "   AND npptype = '1'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     PREPARE upd_npp1 FROM g_sql
     EXECUTE upd_npp1 USING g_plant_1[l_ac].gl_date,g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].p_plant,g_plant_1[l_ac].p_bookno1,
                            l_npp.npp01,l_npp.npp011,l_npp.npp00,l_npp.nppsys
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
#No.FUN-710024--begin
#         CALL cl_err('upd npp:',SQLCA.sqlcode,1)
        LET g_showmsg=l_npp.npp01,"/",l_npp.npp011,"/",l_npp.npp00,"/",l_npp.nppsys 
        CALL s_errmsg('npp01,npp011,npp00,nppsys',g_showmsg,'upd npp:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
 
   #------------------ Insert into abb_file ---------------------------------
   AFTER GROUP OF l_remark   
     LET l_seq = l_seq + 1
    #DISPLAY "Seq:",l_seq AT 2,1  #CHI-9A0021
     #LET g_sql = "INSERT INTO ",g_plant_1[l_ac].gl_dbs CLIPPED,"abb_file",
     LET g_sql = "INSERT INTO ",cl_get_target_table(g_plant_1[l_ac].p_plant,'abb_file'), #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07, ",
                    #    " abb08,abb11,abb12,abb13,abb14,abb15, ",       #No.FUN-810069  
                        " abb08,abb11,abb12,abb13,abb14, ",              #No.FUN-810069  
                        " abb24,abb25,",
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37",
                        ",abblegal ", #FUN-980005 
                        " )",
              #   " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?, ?,?",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?",           #No.FUN-810069  
                 "       ,?,?,?,?,?, ?,?,?)" 
     #-----No.FUN-640142-----
     SELECT azi04 INTO t_azi04 FROM azi_file    #NO.CHI-6A0004
      WHERE azi01 = l_npq.npq24
     #-----No.FUN-640142 END-----
     LET l_amtf= GROUP SUM(l_npq.npq07f)
     LET l_amt = GROUP SUM(l_npq.npq07)
     CALL cl_digcut(l_amtf,t_azi04) RETURNING l_amtf  #No.FUN-640142  #NO.CHI-6A0004
     CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt  #No.FUN-640142
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
     #FUN-980005 add legal 
     CALL s_getlegal(g_plant_1[l_ac].p_plant) RETURNING l_legal  
     #FUN-980005 end legal 
     PREPARE p930_1_p8 FROM g_sql
     EXECUTE p930_1_p8 USING 
                g_plant_1[l_ac].p_bookno1,g_plant_1[l_ac].gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
            #    l_npq.npq14,l_npq.npq15,l_npq.npq24,l_npq.npq25,       #No.FUN-810069  
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                    #No.FUN-810069  
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37
               ,l_legal    #FUN-980005 
     IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#         CALL cl_err('ins abb:',SQLCA.sqlcode,1)  
        LET g_showmsg=g_plant_1[l_ac].p_bookno1,"/",g_plant_1[l_ac].gl_no1,"/",l_seq,l_npq.npq03
        CALL s_errmsg('abb00,abb01,abb02',g_showmsg,'ins abb:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
         LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1' THEN
         LET l_debit  = l_debit  + l_amt
     ELSE 
         LET l_credit = l_credit + l_amt
     END IF
     CALL cl_digcut(l_debit,g_azi04) RETURNING l_debit  #No.FUN-640142
     CALL cl_digcut(l_credit,g_azi04) RETURNING l_credit  #No.FUN-640142
   #------------------ Update aba_file's debit & credit amount --------------
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
      #LET g_sql = "UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file",
      LET g_sql = "UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                  "   SET aba08 = ?,",
                  "       aba09 = ? ",
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? ",
                  "   AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
      PREPARE p930_1_p9 FROM g_sql
      EXECUTE p930_1_p9 USING l_debit,l_credit,l_npp08,g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].p_bookno1 #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) 
         LET g_showmsg=g_plant_1[l_ac].gl_no1,"/",g_plant_1[l_ac].p_bookno1 
         CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba08/09:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
          LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',g_plant_1[l_ac].p_bookno1,g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].gl_date,g_N,'',TRUE)   #No.TQC-B70021

      IF g_aaz85 = 'Y' THEN 
         #若有立沖帳管理就不做自動確認
         #LET g_sql = "SELECT COUNT(*) FROM ",g_plant_1[l_ac].gl_dbs CLIPPED," abb_file,aag_file",
         LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_1[l_ac].p_plant,'abb_file')," ,aag_file", #FUN-A50102         
                     " WHERE abb01 = '",g_plant_1[l_ac].gl_no1,"'",
                     "   AND abb00 = '",g_plant_1[l_ac].p_bookno1,"'",
                     "   AND abb03 = aag01  ",
                     "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
         PREPARE count_pre1 FROM g_sql
         DECLARE count_cs1 CURSOR FOR count_pre1
         OPEN count_cs1 
         FETCH count_cs1 INTO g_cnt
         CLOSE count_cs1
         IF g_cnt = 0 THEN
            IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
           #IF cl_null(g_aba.aba20) THEN LET g_aba.aba20='0' END IF   #MOD-850183 mark
           #IF g_aba.abamksg='N' AND g_aba.aba20='0' THEN   #MOD-850183 mark
            IF g_aba.abamksg='N' THEN                       #MOD-850183
               LET g_aba.aba20='1' 
            #END IF   #MOD-770101
               LET g_aba.aba19 = 'Y'
               #LET g_sql = " UPDATE ",g_plant_1[l_ac].gl_dbs CLIPPED,"aba_file",
#No.TQC-B70021 --begin 
            CALL s_chktic (g_plant_1[l_ac].p_bookno1,g_plant_1[l_ac].gl_no1) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end
               LET g_sql = " UPDATE ",cl_get_target_table(g_plant_1[l_ac].p_plant,'aba_file'), #FUN-A50102
                           "    SET abamksg = ? ,",
                                  " abasign = ? ,", 
                                  " aba18   = ? ,",
                                  " aba19   = ? ,",
                                  " aba20   = ? ,",              #MOD-A80136 
                                  " aba37   = ?  ",              #MOD-A80136
                            " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_1[l_ac].p_plant) RETURNING g_sql #FUN-A50102
               PREPARE upd_aba19_1 FROM g_sql
               EXECUTE upd_aba19_1 USING g_aba.abamksg,g_aba.abasign,
                                       g_aba.aba18  ,g_aba.aba19,
                                       g_aba.aba20  ,
                                       g_user,                   #MOD-A80136
                                       g_plant_1[l_ac].gl_no1,g_plant_1[l_ac].p_bookno1 
               IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#No.FUN-710024--begin
#                 CALL cl_err('upd aba19',STATUS,1) 
                  LET g_showmsg=g_plant_1[l_ac].gl_no1,"/",g_plant_1[l_ac].p_bookno1
                  CALL s_errmsg('aba01,aba00',g_showmsg,'upd aba19:',SQLCA.sqlcode,1) 
#No.FUN-710024--end
                  LET g_success = 'N'
               END IF
            END IF   #MOD-770101
         END IF
      END IF     
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,g_plant_1[l_ac].gl_no1,l_order_1)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no1,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      LET g_plant_1[l_ac].gl_no1=''
      LET g_plant_1[l_ac].gl_no1=g_aba01t
END REPORT
#No.FUN-680088 --end--
#CHI-AC0010
