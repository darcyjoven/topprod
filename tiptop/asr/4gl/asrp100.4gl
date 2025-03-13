# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asrp100.4gl
# Descriptions...: 生產計劃維護作業
# Date & Author..: 06/01/11 by kim
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670103 06/08/01 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680130 06/08/31 By zhuying 欄位形態定義為LIKE
# Modify.........: No.CHI-6A0049 06/10/31 By kim 新增到inb_file,檢驗否的欄位為NULL
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-770003 07/07/01 By hongmei help按鈕不可用
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-AA0062 10/11/05 By yinhy 倉庫權限使用控管修改
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modfiy.........: No.FUN-B70074 11/07/25 By xianghui 添加行業別表的新增於刪除
# Modfiy.........: No.FUN-BB0084 11/12/07 By lixh1 增加數量欄位小數取位
# Modfiy.........: No.FUN-CB0087 12/12/21 By qiull 庫存單據理由碼改善
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-DB0053 13/11/21 By wangrr '儲位'欄位增加開窗


DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE tm1 RECORD
            sre06b   LIKE sre_file.sre06,
            sre06e   LIKE sre_file.sre06,
            sre03    LIKE sre_file.sre03,
            class    LIKE sre_file.sre05,
            betran   LIKE type_file.chr1        #No.FUN-680130 VARCHAR(1) 
          END RECORD
DEFINE g_t1	LIKE oay_file.oayslip           #No.FUN-680130 VARCHAR(5)
DEFINE g_rec_b	LIKE type_file.num10            #No.FUN-680130 INTEGER
DEFINE g_sre    DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
                sel      LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1)
                sre06    LIKE sre_file.sre06,
                sre05    LIKE sre_file.sre05,
                sre04    LIKE sre_file.sre04,
                ima02    LIKE ima_file.ima02,
                ima021   LIKE ima_file.ima021,
                ima55    LIKE ima_file.ima55,
                sre07    LIKE sre_file.sre07,
                sre12    LIKE sre_file.sre12
                END RECORD
DEFINE tm  RECORD                         # Print condition RECORD
		from_w,to_w	LIKE img_file.img02,
		from_l,to_l	LIKE img_file.img03,
		tr_no		LIKE imm_file.imm01, 
		tr_date		LIKE type_file.dat,     #No.FUN-680130 DATE 
		b_seq		LIKE ecd_file.ecd01,
		e_seq		LIKE ecd_file.ecd01,
		b_keeper	LIKE gen_file.gen01,
		e_keeper	LIKE gen_file.gen01,
		order_sw	LIKE type_file.chr1,    #No.FUN-680130 VARCHAR(1)
		more     	LIKE type_file.chr1     # Input more condition(Y/N)    #No.FUN-680130 VARCHAR(1)
              END RECORD
DEFINE   g_cnt       LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_i         LIKE type_file.num5     #count/index for any purpose        #No.FUN-680130 SMALLINT
DEFINE   g_msg       LIKE type_file.chr1000  #No.FUN-680130 VARCHAR(72)
DEFINE   l_ac        LIKE type_file.num5     #No.FUN-680130 SMALLINT
DEFINE   g_ima906    LIKE ima_file.ima906
DEFINE   g_ima907    LIKE ima_file.ima907
DEFINE   g_cnt1      LIKE type_file.num10    #No.FUN-680130 INTEGER
DEFINE   g_factor    LIKE img_file.img21
DEFINE   g_img09     LIKE img_file.img09
 
MAIN
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211

{
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL p100_tm()                       # If background job sw is off
   ELSE
       CALL p100()                      # Read data and create out-file
   END IF
}
   CALL p100_tm()   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
END MAIN
 
FUNCTION p100_tm()
DEFINE li_result      LIKE type_file.num5        #No.FUN-680130 SMALLINT
DEFINE l_sql,l_where  STRING 
DEFINE p_row,p_col    LIKE type_file.num5        #No.FUN-680130 SMALLINT
DEFINE l_imd02        LIKE imd_file.imd02
DEFINE l_eci06        LIKE eci_file.eci06
DEFINE l_ecg02        LIKE ecg_file.ecg02
 
    LET p_row = 4 LET p_col = 12
    OPEN WINDOW p100_w AT p_row,p_col
        WITH FORM "asr/42f/asrp100"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.order_sw= 'Y'
   LET tm.tr_date= TODAY
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   LET tm1.sre06b=TODAY
   LET tm1.sre06e=TODAY
   WHILE TRUE
  
   INPUT BY NAME tm1.sre06b,tm1.sre06e,tm1.sre03,tm1.class,tm1.betran 
               WITHOUT DEFAULTS
     ON ACTION locale
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
      AFTER FIELD sre03
         IF NOT cl_null(tm1.sre03) THEN
            LET g_cnt=0 
            SELECT eci06 INTO l_eci06 FROM eci_file
               WHERE eci01=tm1.sre03
            IF SQLCA.sqlcode THEN
              LET l_eci06=''
              DISPLAY l_eci06 TO FORMONLY.eci06
#             CALL cl_err('','100',1)   #No.FUN-660138
              CALL cl_err3("sel","eci_file",tm1.sre03,"","100","","",1) #No.FUN-660138
              NEXT FIELD sre03
            END IF
            DISPLAY l_eci06 TO FORMONLY.eci06
         ELSE
            DISPLAY '' TO FORMONLY.eci06  
         END IF   
      AFTER FIELD class
         IF NOT cl_null(tm1.class) THEN
            LET g_cnt=0 
            SELECT ecg02 INTO l_ecg02 FROM ecg_file
               WHERE ecg01=tm1.class
            IF SQLCA.sqlcode THEN
              LET l_ecg02=''
              DISPLAY l_ecg02 TO FORMONLY.ecg02
#             CALL cl_err('','100',1)   #No.FUN-660138
              CALL cl_err3("sel","ecg_file",tm1.class,"","100","","",1) #No.FUN-660138
              NEXT FIELD class
            END IF   
            DISPLAY l_ecg02 TO FORMONLY.ecg02
         ELSE
            DISPLAY '' TO FORMONLY.ecg02
         END IF   
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sre03)  
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_eci"
              CALL cl_create_qry() RETURNING tm1.sre03
              DISPLAY tm1.sre03 TO sre03
              NEXT FIELD sre03
            WHEN INFIELD(class)  
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ecg"
              CALL cl_create_qry() RETURNING tm1.class
              DISPLAY tm1.class TO class
              NEXT FIELD class
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      ON ACTION help           #No.TQC-770003                                                                                                     
         CALL cl_show_help()   #No.TQC-770003
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
   END INPUT
 
   
   IF INT_FLAG THEN 
      LET INT_FLAG=0 
      CLOSE WINDOW p100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
 
   LET g_cnt=0
   IF NOT cl_null(tm1.class) THEN
      LET l_where=" AND sre05='",tm1.class,"'"
   ELSE
      LET l_where=""   
   END IF
   IF NOT cl_null(tm1.betran) THEN 
      LET l_where=l_where," AND sre12='",tm1.betran,"'"
   END IF
   LET l_sql="SELECT COUNT(*) FROM sre_file",
             " WHERE sre06 BETWEEN '",tm1.sre06b,"' AND '",tm1.sre06e,"'",
             " AND sre03='",tm1.sre03,"'",l_where,
             " AND sre07<>0 AND sre07 IS NOT NULL"
   PREPARE p100_chk_prepare FROM l_sql
   DECLARE p100_chk CURSOR FOR p100_chk_prepare
   OPEN p100_chk
   FETCH p100_chk INTO g_cnt
   IF g_cnt=0 THEN
      CALL cl_err('','100',0)
      CONTINUE WHILE
   END IF
   
   LET l_sql="SELECT 'N',sre06,sre05,sre04,'','','',sre07,sre12 FROM sre_file",
             " WHERE sre06 BETWEEN '",tm1.sre06b,"' AND '",tm1.sre06e,"'",
             "   AND sre03='",tm1.sre03,"'",l_where,
             "   AND sre07<>0 AND sre07 IS NOT NULL",
             "  ORDER BY sre06,sre05,sre04"
            
   PREPARE p100_prepare FROM l_sql
   DECLARE p100_bcl CURSOR FOR p100_prepare
   
   CALL g_sre.clear()
   
   LET g_cnt = 1
   LET g_rec_b = 0
   
   FOREACH p100_bcl INTO g_sre[g_cnt].*   #單身 ARRAY 填充
     IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
     END IF
   
     SELECT ima02,ima021,ima55 INTO g_sre[g_cnt].ima02,
                                    g_sre[g_cnt].ima021,
                                    g_sre[g_cnt].ima55 FROM ima_file 
                                    WHERE ima01=g_sre[g_cnt].sre04
     IF SQLCA.sqlcode THEN
        LET g_sre[g_cnt].ima02 =''
        LET g_sre[g_cnt].ima021=''
        LET g_sre[g_cnt].ima55 =''
     END IF
     LET g_cnt = g_cnt + 1
     
     IF g_cnt > g_max_rec THEN
        CALL cl_err( '', 9035, 0 )
    EXIT FOREACH
     END IF
     
   END FOREACH
   CALL g_sre.deleteElement(g_cnt)
   LET g_rec_b=g_cnt -1
   
   WHILE TRUE
      INPUT ARRAY g_sre WITHOUT DEFAULTS FROM s_sre.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            
        AFTER INPUT
            EXIT WHILE    
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION controlg      #MOD-4C0121
            CALL cl_cmdask()     #MOD-4C0121
      END INPUT
      LET g_rec_b=ARR_COUNT()
      IF INT_FLAG THEN 
         LET INT_FLAG=0 
         CLOSE WINDOW p100_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM 
      END IF
   END WHILE
 
   LET tm.tr_no=''
   
   INPUT BY NAME tm.* WITHOUT DEFAULTS
      AFTER FIELD from_w
         IF tm.from_w IS NOT NULL THEN
            SELECT imd02 INTO l_imd02 FROM imd_file  WHERE imd01 = tm.from_w
            IF STATUS THEN
#              CALL cl_err('sel imd',STATUS,0) #No.FUN-660138
               CALL cl_err3("sel","imd_file",tm.from_w,"",STATUS,"","sel imd",0) #No.FUN-660138
               NEXT FIELD from_w    
            END IF
            #No.FUN-AA0062  --Begin
            IF NOT s_chk_ware(tm.from_w) THEN
               NEXT FIELD from_w    
            END IF
            #No.FUN-AA0062  --End
           # FUN-D40103 ------Begin------
            IF NOT s_imechk(tm.to_w,tm.to_l) THEN
               NEXT FIELD to_l
            END IF
           #FUN-D40103 ------End--------
         END IF
      AFTER FIELD to_w
         IF tm.to_w IS NOT NULL THEN
            SELECT imd02 INTO l_imd02 FROM imd_file  WHERE imd01 = tm.to_w
            IF STATUS THEN
#              CALL cl_err('sel imd',STATUS,0)    #No.FUN-660138
               CALL cl_err3("sel","imd_file",tm.to_w,"",STATUS,"","sel imd",0) #No.FUN-660138
               NEXT FIELD to_w
            END IF
            #No.FUN-AA0062  --Begin
            IF NOT s_chk_ware(tm.to_w) THEN
               NEXT FIELD to_w    
            END IF
            #No.FUN-AA0062  --End
           # FUN-D40103 ------Begin------
            IF NOT s_imechk(tm.to_w,tm.to_l) THEN
               NEXT FIELD to_l
            END IF
       #FUN-D40103 ------End--------
         END IF
 
      AFTER FIELD from_l
         IF cl_null(tm.from_l) THEN 
            LET tm.from_l = ' ' 
            else
        #FUN-D40103 -----Begin------
          # LET g_cnt=0
          # SELECT COUNT(*) INTO g_cnt FROM ime_file 
          #    WHERE ime01 = from_w
          #      AND ime02 = from_l
          # IF g_cnt=0 THEN
          #    CALL cl_err('','mfg0095',1)
          #    NEXT FIELD from_l
          # END IF   
      #FUN-D40103 -----End--------
         END IF
       #FUN-D40103 ------Begin------
         IF NOT s_imechk(tm.from_w,tm.from_l) THEN
            NEXT FIELD from_l 
         END IF
       #FUN-D40103 ------End-------- 
      AFTER FIELD to_l
         IF cl_null(tm.to_l) THEN 
            LET tm.to_l = ' ' 
         ELSE
          #FUN-D40103 -----Begin-------
          # LET g_cnt=0
          # SELECT COUNT(*) INTO g_cnt FROM ime_file 
          #    WHERE ime01 = to_w
          #      AND ime02 = to_l
          # IF g_cnt=0 THEN
          #    CALL cl_err('','mfg0095',1)
          #    NEXT FIELD to_l
          # END IF   
         #FUN-D40103 -----End--------
         END IF
       #FUN-D40103 ------Begin------
         IF NOT s_imechk(tm.to_w,tm.to_l) THEN
            NEXT FIELD to_l
         END IF
       #FUN-D40103 ------End-------- 
      AFTER FIELD tr_no
         IF tm.tr_no IS NOT NULL THEN
            CALL s_get_doc_no(tm.tr_no) RETURNING g_t1
            CALL s_check_no("aim",tm.tr_no,"","4","","","") RETURNING li_result,tm.tr_no
            IF (NOT li_result) THEN
               CALL cl_err(g_t1,g_errno,0)
               NEXT FIELD tr_no
            END IF
         END IF
      AFTER FIELD b_seq
         IF NOT cl_null(tm.b_seq) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM ecd_file WHERE ecd01=tm.b_seq
            IF g_cnt=0 THEN
               CALL cl_err('','100',1)
               NEXT FIELD b_seq
            END IF
         END IF
      AFTER FIELD e_seq
         IF NOT cl_null(tm.e_seq) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM ecd_file WHERE ecd01=tm.e_seq
            IF g_cnt=0 THEN
               CALL cl_err('','100',1)
               NEXT FIELD e_seq
            END IF
         END IF
 
      AFTER FIELD b_keeper
         IF NOT cl_null(tm.b_keeper) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM gen_file WHERE gen01=tm.b_keeper
            IF g_cnt=0 THEN
               CALL cl_err('','100',1)
               NEXT FIELD b_keeper
            END IF
         END IF
 
      AFTER FIELD e_keeper
         IF NOT cl_null(tm.e_keeper) THEN
            LET g_cnt=0
            SELECT COUNT(*) INTO g_cnt FROM gen_file WHERE gen01=tm.e_keeper
            IF g_cnt=0 THEN
               CALL cl_err('','100',1)
               NEXT FIELD e_keeper
            END IF
         END IF
      
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
         
      ON ACTION controlp  
         CASE 
            WHEN INFIELD(from_w)
#No.FUN-AA0062  --Begin
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_imd"
#               LET g_qryparam.arg1 = 'SW'        #倉庫類別
#               CALL cl_create_qry() RETURNING tm.from_w
               CALL q_imd_1(FALSE,TRUE,tm.from_w,"","","","") RETURNING tm.from_w
#No.FUN-AA0062  --End
               DISPLAY tm.from_w TO from_w
               NEXT FIELD from_w 
            
            WHEN INFIELD(to_w)
#No.FUN-AA0062  --Begin
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_imd"
#               LET g_qryparam.arg1 = 'SW'        #倉庫類別
#               CALL cl_create_qry() RETURNING tm.to_w
                CALL q_imd_1(FALSE,TRUE,tm.to_w,"","","","") RETURNING tm.to_w
#No.FUN-AA0062  --End
               DISPLAY tm.to_w TO to_w
               NEXT FIELD to_w 
 
            #TQC-DB0053--add--str--
            WHEN INFIELD(from_l)
               CALL q_ime_1(FALSE,TRUE,tm.from_l,tm.from_w,"",g_plant,"","","") RETURNING tm.from_l
               DISPLAY tm.from_l TO from_l
               NEXT FIELD from_l 
            WHEN INFIELD(to_l)
               CALL q_ime_1(FALSE,TRUE,tm.to_l,tm.to_w,"",g_plant,"","","") RETURNING tm.to_l
               DISPLAY tm.to_l TO to_l
               NEXT FIELD to_l 
            #TQC-DB0053--add--end

            WHEN INFIELD(tr_no)
               LET g_t1=s_get_doc_no(tm.tr_no)
              #CALL q_smy(FALSE,FALSE,g_t1,'aim','4') RETURNING g_t1
               CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1
               LET tm.tr_no=g_t1       
               DISPLAY tm.tr_no TO tr_no
               NEXT FIELD tr_no
 
            WHEN INFIELD(b_seq)
               CALL q_ecd(FALSE,TRUE,tm.b_seq) RETURNING tm.b_seq
               DISPLAY tm.b_seq TO b_seq
               NEXT FIELD b_seq
 
            WHEN INFIELD(e_seq)
               CALL q_ecd(FALSE,TRUE,tm.e_seq) RETURNING tm.e_seq
               DISPLAY tm.e_seq TO e_seq
               NEXT FIELD e_seq
               
            WHEN INFIELD(b_keeper)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING tm.b_keeper
               DISPLAY tm.b_keeper TO b_keeper
               NEXT FIELD b_keeper
            
            WHEN INFIELD(e_keeper)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING tm.e_keeper
               DISPLAY tm.e_keeper TO e_keeper
               NEXT FIELD e_keeper
         END CASE
         
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
         
      ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
     IF tm.from_l IS NULL THEN LET tm.from_l = ' ' END IF
      IF tm.to_l IS NULL THEN LET tm.to_l = ' ' END IF
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   {
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asrp100'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asrp100','9031',1) 
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_lang CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.order_sw CLIPPED,"'"
         CALL cl_cmdat('asrp100',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW p100_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   }
   CALL cl_wait()
   CALL p100()
   ERROR ""
   
END WHILE
   CLOSE WINDOW p100_w
END FUNCTION
 
FUNCTION p100()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name   #No.FUN-680130 VARCHAR(20)
#       l_time          LIKE type_file.chr8        #No.FUN-6B0014
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680130 VARCHAR(600)
          li_result LIKE type_file.num5,          #No.FUN-680130 SMALLINT
          l_cnt     LIKE type_file.num10,         #No.FUN-680130 INTEGER
          l_flag    LIKE type_file.num5,          #printed or not?     #No.FUN-680130 SMALLINT
          l_bmb03   LIKE bmb_file.bmb03,
          l_bmb06   LIKE bmb_file.bmb06,
          l_bmb07   LIKE bmb_file.bmb07,
          l_bmb08   LIKE bmb_file.bmb08,
          l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima55   LIKE ima_file.ima55,
          l_ima23   LIKE ima_file.ima23,
          l_img10   LIKE img_file.img10,
          l_gen02   LIKE gen_file.gen02,
          l_sre07   LIKE sre_file.sre07,
          sr            RECORD 
                               ima23  LIKE ima_file.ima23 ,
                               gen02  LIKE gen_file.gen02 ,
                               ima01  LIKE ima_file.ima01 ,
                               ima02  LIKE ima_file.ima02 ,
                               ima021 LIKE ima_file.ima021,
                               ima55  LIKE ima_file.ima55 ,
                               sre07  LIKE sre_file.sre07 ,
                               img10  LIKE img_file.img10 
                        END RECORD
   DEFINE l_imni   RECORD LIKE imni_file.*        #FUN-B70074
   DEFINE l_imn01  LIKE imn_file.imn01            #FUN-B70074
   DEFINE l_imn02  LIKE imn_file.imn02            #FUN-B70074
   DEFINE l_imnplant LIKE imn_file.imnplant       #FUN-B70074
 
  #  CALL cl_used('asrp100',g_time,1) RETURNING g_time    #No.FUN-6B0014
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     CALL s_auto_assign_no("aim",tm.tr_no,tm.tr_date,"","","","","","")
        RETURNING li_result,tm.tr_no
     IF (NOT li_result) THEN
         CALL cl_err('','aoo-131',1)
         RETURN
     END IF
 
     CALL cl_outnam('asrp100') RETURNING l_name
     
     DROP TABLE asrp100_tmp
     SELECT ima23,gen02,ima01,ima02,ima021,ima55,sre07,img10 FROM gen_file,ima_file,sre_file,img_file
        WHERE 1=2 INTO TEMP asrp100_tmp
     
     FOR l_cnt=1 TO g_rec_b
        IF g_sre[l_cnt].sel<>'Y' THEN 
           CONTINUE FOR 
        END IF
        LET g_sre[l_cnt].sre06=g_sre[l_cnt].sre06 USING "YYYY-MM-DD"
        LET l_sql="SELECT bmb03,bmb06,bmb07,bmb08,ima02,ima021,ima55,ima23 FROM bmb_file,ima_file ",
                  " WHERE ima01=bmb03 AND bmb01='",g_sre[l_cnt].sre04,"'",
                  "   AND ima108='Y' AND bmb29=ima910",
                  "   AND (bmb04 <='",g_sre[l_cnt].sre06,"' OR bmb04 IS NULL )",
                  "   AND (bmb05 > '",g_sre[l_cnt].sre06,"' OR bmb05 IS NULL )"
        IF NOT cl_null(tm.b_keeper) THEN
           LET l_sql=l_sql," AND ima23>='",tm.b_keeper,"'"
        END IF          
        IF NOT cl_null(tm.e_keeper) THEN
           LET l_sql=l_sql," AND ima23<='",tm.e_keeper,"'"
        END IF
        IF NOT cl_null(tm.b_seq) THEN
           LET l_sql=l_sql," AND bmb09 >='",tm.b_seq,"'"
        END IF
        IF NOT cl_null(tm.e_seq) THEN
           LET l_sql=l_sql," AND bmb09 <='",tm.e_seq,"'"
        END IF
 
        PREPARE p100_prepare1 FROM l_sql
        DECLARE p100_sre_c CURSOR FOR p100_prepare1
        FOREACH p100_sre_c INTO l_bmb03,l_bmb06,l_bmb07,l_bmb08,l_ima02,l_ima021,l_ima55,l_ima23
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           #可用庫存
           SELECT SUM(img10*img21) INTO l_img10 FROM img_file   #MOD-940312
           WHERE img01=l_bmb03 AND img02=tm.from_w
              AND img03=tm.from_l
           IF (SQLCA.sqlcode) OR (l_img10 IS NULL) THEN
              LET l_img10=0
           END IF
           LET l_gen02=''
           SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=l_ima23
           IF g_sre[l_cnt].sre07 IS NULL THEN LET g_sre[l_cnt].sre07=0 END IF
           LET l_sre07=g_sre[l_cnt].sre07*(l_bmb06/l_bmb07)*(1+l_bmb08/100)
           LET g_cnt=0
           SELECT COUNT(*) INTO g_cnt FROM asrp100_tmp WHERE ima01=l_bmb03
           IF g_cnt=0 THEN
              INSERT INTO asrp100_tmp (ima23,gen02,ima01,ima02,ima021,ima55,sre07,img10)
                 VALUES (l_ima23,l_gen02,l_bmb03,l_ima02,l_ima021,l_ima55,l_sre07,l_img10)    
           ELSE
              UPDATE asrp100_tmp SET sre07=sre07+l_sre07 WHERE ima01=l_bmb03
           END IF
        END FOREACH
     END FOR
 
     LET l_sql="SELECT * FROM asrp100_tmp"
     PREPARE p100_p1 FROM l_sql
     DECLARE p100_co CURSOR FOR p100_p1
     
     DROP TABLE p100_imm_tmp
     DROP TABLE p100_imn_tmp
     SELECT * FROM imm_file WHERE 1=2 INTO TEMP p100_imm_tmp
     SELECT * FROM imn_file WHERE 1=2 INTO TEMP p100_imn_tmp
     LET g_success='Y'
     LET g_pageno=0
     START REPORT p100_rep TO l_name
     
     LET l_flag=FALSE
     FOREACH p100_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('p100_co:',SQLCA.sqlcode,1)                 
            EXIT FOREACH
        END IF
        LET l_flag=TRUE
        OUTPUT TO REPORT p100_rep(sr.*)
     END FOREACH
     
     FINISH REPORT p100_rep
     
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
{
#    IF g_success='Y' THEN
#       COMMIT WORK
#    ELSE
#       ROLLBACK WORK
#    END IF
}
     IF (g_success='Y') AND (l_flag) THEN
        IF cl_confirm('asr-005') THEN
           BEGIN WORK
           INSERT INTO imm_file SELECT * FROM p100_imm_tmp
           IF SQLCA.sqlcode THEN
#             CALL cl_err('ins imm',SQLCA.sqlcode,1)   #No.FUN-660138
              CALL cl_err3("ins","imm_file","","",SQLCA.sqlcode,"","ins imm",1) #No.FUN-660138
              LET g_success='N'
           END IF
           INSERT INTO imn_file SELECT * FROM p100_imn_tmp
           IF SQLCA.sqlcode THEN
#             CALL cl_err('ins imm',SQLCA.sqlcode,1)   #No.FUN-660138
              CALL cl_err3("ins","imn_file","","",SQLCA.sqlcode,"","ins imm",1) #No.FUN-660138
              LET g_success='N'
           #FUN-B70074-add-str--
           ELSE
              IF NOT s_industry('std') THEN
                 LET l_sql ="SELECT imn01,imn02,imnplant FROM p100_imn_tmp"
                 PREPARE p100_imn_tem_pre FROM l_sql
                 DECLARE p100_imn_tem_cus CURSOR FOR p100_imn_tem_pre
                 FOREACH p100_imn_tem_cus INTO l_imn01,l_imn02,l_imnplant
                    INITIALIZE l_imni.* TO NULL
                    LET l_imni.imni01 = l_imn01
                    LET l_imni.imni02 = l_imn02
                    IF NOT s_ins_imni(l_imni.*,l_imnplant) THEN
                       LET g_success ='N'
                       EXIT FOREACH
                    END IF
                 END FOREACH
              END IF
           #FUN-B70074-add-end--
           END IF
 
           #update sre12
           IF g_success='Y' THEN
              FOR l_cnt=1 TO g_rec_b
                 IF (g_sre[l_cnt].sel<>'Y') AND (g_sre[l_cnt].sre12<>'Y') THEN 
                    CONTINUE FOR 
                 END IF
                 UPDATE sre_file set sre12='Y' WHERE sre03=tm1.sre03
                                                 AND sre04=g_sre[l_cnt].sre04
                                                 AND sre05=g_sre[l_cnt].sre05
                                                 AND sre06=g_sre[l_cnt].sre06
                 IF (SQLCA.sqlcode) OR (SQLCA.sqlerrd[3]=0) THEN
#                   CALL cl_err('upd sre',SQLCA.sqlcode,1) #FUN-660138
                    CALL cl_err3("upd","sre_file",tm1.sre03,g_sre[l_cnt].sre04,SQLCA.sqlcode,"","upd sre",1) # FUN-660138
                    LET g_success='N'
                    EXIT FOR
                 END IF
              END FOR
           END IF
 
           IF g_success='Y' THEN
              COMMIT WORK 
              DISPLAY tm.tr_no TO tr_no
           ELSE
              ROLLBACK WORK
           END IF
           
           IF tm.tr_no IS NOT NULL AND g_success='Y' THEN        
              LET g_msg="aimt324 '",tm.tr_no,"'"
              CALL cl_cmdrun(g_msg)
           END IF
        END IF   
     END IF
     
  #  CALL cl_used('asfp100',g_time,2) RETURNING g_time   #No.FUN-6B0014
     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END FUNCTION
 
REPORT p100_rep(sr)
 DEFINE li_result   LIKE type_file.num5          #No.FUN-680130 SMALLINT
 DEFINE l_last_sw       LIKE type_file.chr1,     #NO.FUN-680130 VARCHAR(1)	
        l_cnt           LIKE type_file.num10,    #No.FUN-680130 INTEGER
        l_imm	        RECORD LIKE imm_file.*,
        l_imn	        RECORD LIKE imn_file.*,
        to_qty,from_qty	LIKE img_file.img10,     #No.FUN-680130 DEC(15,3)
#       l_qty,l_ima262	LIKE sre_file.sre07,     #No.FUN-680130 DEC(15,3)
        l_qty,l_avl_stk	LIKE sre_file.sre07,     #NO.FUN-A20044
        i,j,k		LIKE type_file.num10,    #No.FUN-680130 INTEGER
        l_ima64         LIKE ima_file.ima64,
        l_ima641        LIKE ima_file.ima641,
        l_gfe03         LIKE gfe_file.gfe03,
        sr            RECORD 
                             ima23  LIKE ima_file.ima23 ,
                             gen02  LIKE gen_file.gen02 ,
                             ima01  LIKE ima_file.ima01 ,
                             ima02  LIKE ima_file.ima02 ,
                             ima021 LIKE ima_file.ima021,
                             ima55  LIKE ima_file.ima55 ,
                             sre07  LIKE sre_file.sre07 ,
                             img10  LIKE img_file.img10 
                      END RECORD,
       l_eca03 LIKE eca_file.eca03
DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
DEFINE   l_store     STRING                           #FUN-CB0087
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ima23,sr.ima01
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<'  #,'/pageno'
      
      IF NOT cl_null(tm.tr_no) AND g_pageno=1 THEN
         INITIALIZE l_imm.* TO NULL
         DISPLAY BY NAME tm.tr_no
         LET l_imm.imm01=tm.tr_no
         LET l_imm.imm02=tm.tr_date
         LET l_imm.imm03='N'
         LET l_imm.imm04='N'
         LET l_imm.immconf='N'
         LET l_imm.imm07=0
         LET l_imm.imm10='1'
         LET l_imm.immacti='Y'
         LET l_imm.immuser=g_user
         LET l_imm.immgrup=g_grup
         LET l_imm.immconf='N' #FUN-670103
         LET l_imm.imm14=g_grup #FUN-670103
 
         LET l_imm.immplant = g_plant #FUN-980008 add
         LET l_imm.immlegal = g_legal #FUN-980008 add
 
         INITIALIZE l_imn.* TO NULL
         LET l_imn.imn02=0
         #FUN-A60034--add---str---
         #FUN-A70104--mod---str---
         LET l_imm.immmksg = g_smy.smyapr #是否簽核
         LET l_imm.imm15 = '0'            #簽核狀況
         LET l_imm.imm16 = g_user         #申請人
         #FUN-A70104--mod---end---
         #FUN-A60034--add---end---
         INSERT INTO p100_imm_tmp VALUES(l_imm.*)
         IF STATUS THEN
#           CALL cl_err('ins imm_tmp:',STATUS,1)   #No.FUN-660138
            CALL cl_err3("ins","p100_imm_tmp",l_imm.imm01,"",SQLCA.sqlcode,"","ins imm_tmp",1) #No.FUN-660138
            LET g_success='N'
         END IF
      END IF
 
      PRINT
      PRINT g_x[13] CLIPPED,tm.tr_no CLIPPED,
            COLUMN 29,g_x[14] CLIPPED,tm.from_w CLIPPED,
            COLUMN 55,g_x[15] CLIPPED,tm.to_w
      PRINT COLUMN 29,g_x[18] CLIPPED,tm.from_l CLIPPED,
            COLUMN 55,g_x[19] CLIPPED,tm.to_l
            
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash
 
   BEFORE GROUP OF sr.ima23
      IF g_pageno=1 THEN
         PRINT COLUMN  1,g_x[37] CLIPPED,
               COLUMN 12,g_x[38] CLIPPED,
               COLUMN 43,g_x[39] CLIPPED,
               COLUMN 48,g_x[40] CLIPPED,
               COLUMN 64,g_x[41] CLIPPED
         PRINT g_x[42]      
         FOR l_cnt=1 TO g_rec_b
            IF g_sre[l_cnt].sel<>'Y' THEN 
               CONTINUE FOR
            END IF
            PRINT COLUMN  1,g_sre[l_cnt].sre06,
                  COLUMN 12,g_sre[l_cnt].sre04,
                  COLUMN 43,g_sre[l_cnt].ima55,
                  COLUMN 48,cl_numfor(g_sre[l_cnt].sre07,15,3),
                  COLUMN 64,g_sre[l_cnt].sre12
            PRINT COLUMN 12,g_sre[l_cnt].ima02
            PRINT COLUMN 12,g_sre[l_cnt].ima021
         END FOR
         PRINT g_dash
      END IF
      PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
      PRINT g_dash1
      LET l_last_sw = 'n'  
      
   ON EVERY ROW
            
      LET l_qty=sr.sre07
     #ref asfr204
      SELECT SUM(img10*img21) INTO to_qty FROM img_file   #MOD-940312
       WHERE img01=sr.ima01 AND img02=tm.from_w
         AND img03=tm.from_l
      LET l_qty= sr.sre07
      LET l_ima64=0
      LET l_ima641=0
      SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
         WHERE ima01=sr.ima01
      IF l_ima64 IS NULL THEN LET l_ima64=0 END IF
      IF l_ima641 IS NULL THEN LET l_ima641=0 END IF
      IF to_qty IS NULL THEN LET to_qty=0 END IF
         IF l_ima64 != 0 THEN		# 發料倍量
            LET k = (l_qty / l_ima64) + 0.999
            LET l_qty = l_ima64 * k
         END IF
         IF l_qty < l_ima641 THEN		# 最小發料量
            LET l_qty = l_ima641
         END IF
         IF tm.tr_no IS NOT NULL THEN
            LET l_imn.imn01=tm.tr_no
            LET l_imn.imn02=l_imn.imn02+1
            LET l_imn.imn03=sr.ima01
            LET l_imn.imn04=tm.from_w
           #---98/10/23 modify
           #LET l_imn.imn05=' '
            LET l_imn.imn05=tm.from_l
            LET l_imn.imn06=' '
            LET l_imn.imn09=NULL
            SELECT ima25 INTO l_imn.imn09 FROM ima_file WHERE ima01=sr.ima01
            LET l_imn.imn10=l_qty
            LET l_imn.imn10=s_digqty(l_imn.imn10,l_imn.imn09)    #FUN-BB0084
            LET l_imn.imn15=tm.to_w
          # LET l_imn.imn16=' '
            LET l_imn.imn16=tm.to_l
            LET l_imn.imn17=' '
            LET l_imn.imn20=l_imn.imn09
            LET l_imn.imn21=1
            LET l_imn.imn22=l_imn.imn10*l_imn.imn21
            LET l_imn.imn22=s_digqty(l_imn.imn22,l_imn.imn20)    #FUN-BB0084  
            LET l_imn.imn29='N' #CHI-6A0049
            IF g_sma.sma115 = 'Y' THEN
               SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
                WHERE ima01=l_imn.imn03
               IF SQLCA.sqlcode =100 THEN                                                  
                  IF l_imn.imn03 MATCHES 'MISC*' THEN                                
                     SELECT ima906,ima907 INTO g_ima906,g_ima907                               
                       FROM ima_file WHERE ima01='MISC'                                    
                  END IF                                                                   
               END IF                                                                      
               #---------------------來源---------------------
               LET g_img09 = NULL
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=l_imn.imn03  AND img02=l_imn.imn04
                  AND img03=l_imn.imn05  AND img04=l_imn.imn06
               IF cl_null(g_img09) THEN LET g_img09=l_imn.imn09 END IF
               LET l_imn.imn30 = l_imn.imn09
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn30,g_img09)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN
                  LET g_factor = 1
               END IF
               LET l_imn.imn31 = g_factor
               LET l_imn.imn32 = l_imn.imn10
               LET l_imn.imn33 = g_ima907
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn33,g_img09)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN
                  LET g_factor = 1
               END IF
               LET l_imn.imn34 = g_factor
               LET l_imn.imn35 = 0
               IF g_ima906 = '3' THEN
                  LET g_factor = 1
                  CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn33)
                       RETURNING g_cnt1,g_factor
                  IF g_cnt1 = 1 THEN
                     LET g_factor = 1
                  END IF
                  LET l_imn.imn35=l_imn.imn32*g_factor
                  LET l_imn.imn35=s_digqty(l_imn.imn35,l_imn.imn33)   #FUN-BB0084
               END IF
               #---------------------目的---------------------
               LET g_img09 = NULL
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=l_imn.imn03  AND img02=l_imn.imn15
                  AND img03=l_imn.imn16  AND img04=l_imn.imn17
               IF cl_null(g_img09) THEN LET g_img09=l_imn.imn09 END IF
               LET l_imn.imn40 = l_imn.imn09
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn40,g_img09)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN
                  LET g_factor = 1
               END IF
               LET l_imn.imn41 = g_factor
               LET l_imn.imn42 = l_imn.imn22
               LET l_imn.imn43 = g_ima907
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn43,g_img09)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN
                  LET g_factor = 1
               END IF
               LET l_imn.imn44 = g_factor
               LET l_imn.imn45 = 0
               IF g_ima906 = '3' THEN
                  LET g_factor = 1
                  CALL s_umfchk(l_imn.imn03,l_imn.imn40,l_imn.imn43)
                       RETURNING g_cnt1,g_factor
                  IF g_cnt1 = 1 THEN
                     LET g_factor = 1
                  END IF
                  LET l_imn.imn45=l_imn.imn42*g_factor
                  LET l_imn.imn45=s_digqty(l_imn.imn45,l_imn.imn43)     #FUN-BB0084
               END IF
               #--------------轉換率-------------------
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN
                  LET g_factor = 1
               END IF
               LET l_imn.imn51=g_factor
               LET g_factor = 1
               CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
                    RETURNING g_cnt1,g_factor
               IF g_cnt1 = 1 THEN
                  LET g_factor = 1
               END IF
               LET l_imn.imn52=g_factor
            END IF
            #No.FUN-560084  --end
            #FUN-670103...............begin
            SELECT eca03 INTO l_eca03 FROM eca_file,eci_file 
                                     WHERE eci01=tm1.sre03
                                       AND eca01=eci03
            IF SQLCA.sqlcode THEN
               LET l_eca03=NULL
            END IF
            LET l_imn.imn9301=s_costcenter(l_eca03)
            LET l_imn.imn9302=l_imn.imn9301
            #FUN-670103...............end
 
            LET l_imn.imnplant=g_plant #FUN-980008 add
            LET l_imn.imnlegal=g_legal #FUN-980008 add
            #FUN-CB0087---qiull---add---str---
            IF g_aza.aza115 = 'Y' THEN
               LET l_store = ''
               IF NOT cl_null(l_imn.imn04) THEN
                  LET l_store = l_store,l_imn.imn04
               END IF
               IF NOT cl_null(l_imn.imn15) THEN
                  IF NOT cl_null(l_store) THEN
                     LET l_store = l_store,"','",l_imn.imn15
                  ELSE
                     LET l_store = l_store,l_imn.imn15
                  END IF
               END IF
               CALL s_reason_code(l_imn.imn01,'','',l_imn.imn03,l_store,l_imm.imm16,l_imm.imm14) RETURNING l_imn.imn28
               IF cl_null(l_imn.imn28) THEN
                  CALL cl_err('','aim-425',1)
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-CB0087---qiull---add---end---

            INSERT INTO p100_imn_tmp VALUES(l_imn.*)
              IF STATUS THEN 
  #           CALL cl_err('ins imn:',STATUS,1) #No.FUN-660138
              LET g_success='N'   
              CALL cl_err3("ins","p100_imn_tmp",l_imn.imn01,l_imn.imn02,STATUS,"","ins imn:",1) #No.FUN-660138
            END IF
         END IF
 
      SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01=sr.ima55
      IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN
         LET l_gfe03=0
      END IF
 
      LET sr.gen02=' ',sr.gen02
      PRINTX name=D1 COLUMN g_c[31],sr.ima23,sr.gen02,
                     COLUMN g_c[32],sr.ima01,
                     COLUMN g_c[33],sr.ima02,
                     COLUMN g_c[34],sr.ima021,
                     COLUMN g_c[35],cl_numfor(sr.sre07,35,l_gfe03),
                     COLUMN g_c[36],cl_numfor(sr.img10,36,3)
         
{
         SELECT SUM(img10) INTO from_qty FROM img_file
          WHERE img01=sr.sfa03 AND img02=tm.from_w
            AND img03=tm.from_l
 
         PRINT COLUMN 01,sr.ima23,
               COLUMN 07,sr.sfa03 CLIPPED,
#NO.TQC-5B0125 START---------
               #COLUMN 23,sr.ima02 CLIPPED,
               #COLUMN 58,l_qty USING '---,---,--&',
               #COLUMN 69,from_qty USING '---,---,--&'
               COLUMN 33,sr.ima02 CLIPPED,
               COLUMN 98,l_qty USING '---,---,--&',
               COLUMN 109,from_qty USING '---,---,--&'
#NO.TQC-5B0125 END------
 
}
{
         IF tm.QVL_flag='Y' THEN
            DECLARE r204_QVL_c CURSOR FOR
               SELECT * FROM bml_file
                      WHERE bml01 = sr.sfa03
                      ORDER BY bml03
            LET g_cnt=0
            FOREACH r204_QVL_c INTO l_bml.*
               FOR g_i=1 TO 100
                  IF l_bml.bml02='ALL' OR l_bml.bml02=g_part[g_i] THEN
                     EXIT FOR
                  END IF
               END FOR
               IF g_i=100 THEN CONTINUE FOREACH END IF
               IF g_cnt=0 THEN PRINT "      QVL:"; END IF
               IF g_cnt=8 THEN PRINT PRINT "      QVL:"; END IF
               PRINT l_bml.bml04 CLIPPED,',';
               LET g_cnt=g_cnt+1
            END FOREACH
            IF g_cnt>0 THEN PRINT END IF
         END IF
        #IF sr.sfa26 MATCHES '[1234]' AND     #FUN-A20037
         IF sr.sfa26 MATCHES '[123478]' AND   #FUN-A20037
           (tm.SUB_flag='2' OR (tm.SUB_flag='3' AND l_qty>from_qty)) THEN
            DECLARE r204_SUB_c CURSOR FOR
#           SELECT bmd02,bmd04,bmd07,bmd08, ima02,ima262 FROM bmd_file, ima_file #NO.FUN-A20044
            SELECT bmd02,bmd04,bmd07,bmd08, ima02,0 FROM bmd_file, ima_file      #NO.FUN-A20044
                   WHERE bmd01 = sr.sfa03 AND bmd04=ima01
                   GROUP BY bmd02,bmd04,bmd07,bmd08
                      ORDER BY bmd04
            LET g_cnt=0
            FOREACH r204_SUB_c INTO l_bmd02,l_bmd04,l_bmd07,l_bmd08,
#                                   l_ima02,l_ima262          #NO.FUN-A20044
                                    l_ima02,l_avl_stk         #NO.FUN-A20044
               #print l_bmd02,l_bmd04,l_bmd08,l_ima262
               CALL s_getstock(l_bmd04,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
               LET l_avl_stk = l_n3                           #NO.FUN-A20044
#              IF l_ima262<=0 THEN CONTINUE FOREACH END IF    #NO.FUN-A20044
               IF l_avl_stk<=0 THEN CONTINUE FOREACH END IF   #NO.FUN-A20044
               FOR g_i=1 TO 100
                  IF l_bmd08='ALL' OR l_bmd08=g_part[g_i] THEN
                     EXIT FOR
                  END IF
               END FOR
               IF g_i>=100 THEN CONTINUE FOREACH END IF
               IF l_bmd02=1 THEN PRINT "      U:"; END IF
               IF l_bmd02=2 THEN PRINT "      S:"; END IF
               PRINT l_bmd04,' ',l_ima02 CLIPPED, 7 SPACES,
#                    l_ima262 USING '---,---,--&',' (',      #NO.FUN-A20044
                     l_avl_stk USING '---,---,--&',' (',     #NO.FUN-A20044
                     l_bmd08 CLIPPED,')'
               LET g_cnt=g_cnt+1
            END FOREACH
         END IF
      ELSE            #00/05/19 modify   #若庫存不足也出報表
         SELECT SUM(img10) INTO from_qty FROM img_file
          WHERE img01=sr.sfa03 AND img02=tm.from_w
            AND img03=tm.from_l
         PRINT COLUMN 01,sr.ima23[1,6],
               COLUMN 07,sr.sfa03 CLIPPED,
#NO.TQC-5B0125 START-------
               #COLUMN 27,sr.ima02 CLIPPED,
               #COLUMN 58,l_qty USING '---,---,--&',
               #COLUMN 69,from_qty USING '---,---,--&'
               COLUMN 37,sr.ima02 CLIPPED,
               COLUMN 98,l_qty USING '---,---,--&',
               COLUMN 109,from_qty USING '---,---,--&'
#NO.TQC-5B0125 END--------
#No.FUN-550067-end      
}      
   ON LAST ROW
      PRINT g_dash[1,g_len]
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash[1,g_len]
              PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE SKIP 2 LINE
      END IF
 
      PRINT
      IF l_last_sw = 'n' THEN
         IF g_memo_pagetrailer THEN
             PRINT g_x[9]
             PRINT g_memo
         ELSE
             PRINT
             PRINT
         END IF
      ELSE
          PRINT g_x[9]
          PRINT g_memo
      END IF
         
END REPORT
