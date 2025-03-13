# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Pattern name...: apsp810.4gl 
# Descriptions...: APS 請購單產生作業
# Date & Author..: 2008/04/24 By Mandy #FUN-840008
# Modify.........: TQC-860035 2008/06/20 By Mandy ins_pmk()時,g_t1的值為NULL,導致沒有產生pmk01的編碼
# Modify.........: FUN-870013 2008/07/04 By Mandy 庫存/採購單位問題
# Modify.........: TQC-870030 2008/07/21 By Mandy 無法產生apsp810明細單身資料
# Modify.........: FUN-880010 2008/08/04 By Duke 單頭QBE新增buyer採購員,planner計劃員,單身增加這二個資料欄位
# Modify.........: TQC-880040 2008/08/22 By Mandy 資料抓取來源,要增加判斷vob05=1的資料,才是屬於APS建議產生請購單的資料
# Modify.........: TQC-8B0040 2008/11/19 By Mandy APS排程規劃後,回傳採購令結果的ERP預計抵達日期(vob14)應改拋至到廠日(pml34)
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No:FUN-930086 09/03/16 By Duke  單身ADD pml35 TP確認到庫日, vob40 APS建議到庫日
# Modify.........: No:FUN-930118 09/03/30 By Duke QBE增加料件,需求供給訂單,APS建議到廠日, 單身增加供給需求訂單,供給法則
# Modify.........: No:TQC-990134 09/09/24 By Mandy SQL語法調整,因為5.0此種寫法r.c2 會err
# Modify.........: No:TQC-990134 09/09/24 By Mandy 將行業別的寫法mark
# Modify.........: No:FUN-990096 09/10/05 By Mandy pmk42匯率不能僅def 1,應重算
# Modify.........: No:FUN-9A0028 09/10/13 By Mandy (1)vob33的量,已是用採購數量來看,不需要再*單位換算率
#                                                  (2)將單身欄位vob25,vob26,vob33 隱藏
# Modify.........: No:FUN-9B0089 09/11/11 By Mandy (1)單頭條件選項增加"單據日期",產生請購單時,是以單頭的單據日期作為開單日
# Modify.........: No:FUN-9B0090 09/11/11 By Mandy (1)單身欄位加show vob08--原開立量(含虛擬耗用)
# Modify.........: No:CHI-A70049 10/07/28 By Pengu 將多餘的DISPLAY程式mark 
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980006 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No.FUN-9C0072 10/10/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版----------------------end---
# Modify.........: No:FUN-9A0079 11/06/15 By Abby  產生請購單時,要在增加判斷單據別的"簽核否"設定,若簽核否為Y,則產生的請購單不自動確認,且需走簽核程序
# Modify.........: No.FUN-B80053 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B80077 11/08/19 By Abby  apsp810 拋至pml09(請購單位/庫存單位的轉換率)應透過s_umfchk()即時取得轉換率,而不是抓ima44_fac
# Modify.........: No:FUN-910088 11/11/24 By chenjing 	 增加數量欄位小數取位
# Modify.........: No:FUN-BB0103 11/11/28 By Abby  (1)在CALL 幣別轉換的副程式s_curr3時,需判斷傳入的幣別(pmk22)不為NULL,才需CALL s_curr3
#                                                  (2)若幣別(pmk22)的值為NULL,則預設匯率(pmk42) = 1
# Modify.........: No:FUN-C40039 12/10/05 By Abby  調整p810_cre_temp()變數型態(vob01,vob02,vob03)
# Modify.........: No:FUN-CC0075 12/12/14 By Nina  (1)apsp810單身確認到庫日期(pml35)一開始顯示預設APS回饋的vob40
#                                                  (2)拋至apmt420的pml33交貨日期邏輯調整  
# Modify.........: No:FUN-D10086 13/01/17 By Mandy apsp810 產生請購單 For GP5.3 版本差異欄位調整

DATABASE ds

GLOBALS "../../config/top.global"

GLOBALS                                                                                                                             
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04 #FUN-840008
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10                                                                                         
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11                                                                                         
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17   
  DEFINE g_seq_item     LIKE type_file.num5  
END GLOBALS 

DEFINE g_pmk		RECORD LIKE pmk_file.*
DEFINE g_ima            RECORD LIKE ima_file.*  #FUN-880010
DEFINE g_pml		RECORD LIKE pml_file.*
DEFINE mxno  		LIKE type_file.num10  
DEFINE summary_flag	LIKE type_file.chr1   
DEFINE g_t1    	        LIKE type_file.chr5   
DEFINE l_za05  	        LIKE type_file.chr1000
DEFINE g_sql	        STRING
DEFINE g_wc 	        STRING
DEFINE i,j,k		LIKE type_file.num10  
DEFINE g_pmkmksg        LIKE pmk_file.pmkmksg
DEFINE g_pmksign        LIKE pmk_file.pmksign
DEFINE g_pmkdays        LIKE pmk_file.pmkdays
DEFINE g_pmkprit        LIKE pmk_file.pmkprit
DEFINE g_smydmy4        LIKE smy_file.smydmy4
DEFINE g_ima43          LIKE ima_file.ima43    #FUN-870010
DEFINE g_ima67          LIKE ima_file.ima67    #FUN-870010
DEFINE g_apsdb          LIKE type_file.chr21
DEFINE g_sma115         LIKE sma_file.sma115
DEFINE #l_sql            LIKE type_file.chr1000  
       l_sql        STRING       #NO.FUN-910082  
DEFINE l_zaa02          LIKE zaa_file.zaa02
DEFINE g_change_lang    LIKE type_file.chr1     
DEFINE g_i              LIKE type_file.num5     
DEFINE g_msg            LIKE ze_file.ze03       
DEFINE g_vob01          LIKE vob_file.vob01     
DEFINE g_vob02          LIKE vob_file.vob02
DEFINE g_pmk01          LIKE pmk_file.pmk01     
DEFINE g_cnt            LIKE type_file.num10    
DEFINE g_rec_b          LIKE type_file.num5       #單身筆數    
DEFINE l_ac             LIKE type_file.num5       #目前處理的ARRAY CNT
DEFINE g_forupd_sql     STRING                    #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_select         LIKE type_file.num5
DEFINE g_vob           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         select         LIKE type_file.chr1,               
         vob10          LIKE vob_file.vob10,
         pmc03          LIKE pmc_file.pmc03,
         buyer          LIKE ima_file.ima43, #FUN-880010 add
         planner        LIKE ima_file.ima67, #FUN-880010 add
         vob07          LIKE vob_file.vob07,
         ima02          LIKE ima_file.ima02,
         ima021         LIKE ima_file.ima021,
         vob11          LIKE vob_file.vob11,
         vob25          LIKE vob_file.vob25, #FUN-870013 add
         vob26          LIKE vob_file.vob26, #FUN-870013 add
         vob15          LIKE vob_file.vob15,
         vob08          LIKE vob_file.vob08, #FUN-9B0090 add
         pml20          LIKE pml_file.pml20,
         pml34          LIKE pml_file.pml34, #TQC-8B0040 add
         pml35          LIKE pml_file.pml35, #TQC-8B0040 mark  #FUN-930086 unmark
         vob33          LIKE vob_file.vob33,
         vob33_po       LIKE vob_file.vob33, #FUN-870013 add
         vob14          LIKE vob_file.vob14,
         vob40          LIKE vob_file.vob40, #FUN-930086 ADD
         vob03          LIKE vob_file.vob03,
         vod17          LIKE vob_file.vob17, #FUN-930118 ADD
         vod42          LIKE vob_file.vob42  #FUN-930118 ADD
                       END RECORD
DEFINE g_vob_t         RECORD                  #程式變數 (舊值)
         select         LIKE type_file.chr1,               
         vob10          LIKE vob_file.vob10,
         pmc03          LIKE pmc_file.pmc03,
         buyer          LIKE ima_file.ima43, #FUN-880010 add
         planner        LIKE ima_file.ima67, #FUN-880010 add
         vob07          LIKE vob_file.vob07,
         ima02          LIKE ima_file.ima02,
         ima021         LIKE ima_file.ima021,
         vob11          LIKE vob_file.vob11,
         vob25          LIKE vob_file.vob25, #FUN-870013 add
         vob26          LIKE vob_file.vob26, #FUN-870013 add
         vob15          LIKE vob_file.vob15,
         vob08          LIKE vob_file.vob08, #FUN-9B0090 add
         pml20          LIKE pml_file.pml20,
         pml34          LIKE pml_file.pml34, #TQC-8B0040 add
         pml35          LIKE pml_file.pml35, #TQC-8B0040 mark  #FUN-930086 unmark
         vob33          LIKE vob_file.vob33,
         vob33_po       LIKE vob_file.vob33, #FUN-870013 add
         vob14          LIKE vob_file.vob14,
         vob40          LIKE vob_file.vob40, #FUN-930086 ADD
         vob03          LIKE vob_file.vob03,
         vod17          LIKE vob_file.vob17, #FUN-930118 ADD
         vod42          LIKE vob_file.vob42  #FUN-930118ADD
                    END RECORD

MAIN
   DEFINE   l_time      LIKE type_file.chr8     
   DEFINE   p_row,p_col LIKE type_file.num5     
   DEFINE   l_flag      LIKE type_file.chr1     
   DEFINE   ls_date     STRING                  

   OPTIONS
      #FORM LINE     FIRST + 2, #FUN-B50022 mark
      #MESSAGE LINE  LAST,      #FUN-B50022 mark
      #PROMPT LINE   LAST,      #FUN-B50022 mark
       INPUT NO WRAP
   DEFER INTERRUPT				 

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APS")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-B80053--l_time改為g_time--
   #CALL cl_used(g_prog,l_time,1) RETURNING l_time 

   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

   WHILE TRUE
      CLEAR FORM  
      CALL p810_cre_tmp()              # 建立本程式所有會用到的TEMP TABLE
      IF g_bgjob = "N" THEN
         CALL p810_ask()               # Ask for first_flag, data range or exist
         LET g_rec_b = 0
         CALL p810_b_fill()            #單身填充
         IF g_rec_b = 0 THEN
             CALL cl_err('','apm-204',1) #單身無符合條件之資料
             CONTINUE WHILE
         END IF
         CALL p810_b()
         LET g_select = 0
         CALL p810_ins_vob_tmp()
         IF g_select = 0 THEN
              #沒有符合條件的資料,請重新選擇
              CALL cl_err('','aic-044',1)
              CONTINUE WHILE
         END IF
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p810()
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p810
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p810()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
 END WHILE
 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #No.FUN-B80053--l_time改為g_time--
 #CALL cl_used(g_prog,l_time,2) RETURNING l_time 
END MAIN

FUNCTION p810_ask()
   DEFINE   l_gen02   LIKE gen_file.gen02,
            l_gen03   LIKE gen_file.gen03,
            l_gem02   LIKE gem_file.gem02
   DEFINE   li_result LIKE type_file.num5     
   DEFINE   lc_cmd    LIKE type_file.chr1000
   DEFINE   p_row,p_col LIKE type_file.num5 
   DEFINE   l_vzy12   LIKE vzy_file.vzy12   #FUN-930118  ADD


   OPEN WINDOW p810_w AT p_row,p_col
        WITH FORM "aps/42f/apsp810" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   
   CALL cl_ui_init()
  #CALL cl_set_comp_visible("vob03",FALSE) #FUN-870013 mark
   CALL cl_set_comp_visible("vob35",FALSE) #FUN-870013 add
   CALL cl_set_comp_visible("vob25,vob26,vob33",FALSE) #FUN-9A0028 add 將單身欄位vob25,vob26,vob33 隱藏


   #FUN-930118  ADD --STR--
    SELECT vzy01,vzy02 INTO g_vob01,g_vob02
      FROM vzy_file
        #TQC-990134-------mod--------str--------
        #,(SELECT max(vzy12) mvzy12 FROM vzy_file
        #   WHERE vzy10 is NULL
        #     AND vzy00 = g_plant
        #     AND vzy12 is not NULL)
      WHERE vzy10 is NULL  
        AND vzy00 = g_plant  
       #AND vzy12 = mvzy12
        AND vzy12 = (SELECT MAX(vzy12) FROM vzy_file
                      WHERE vzy10 IS NULL
                        AND vzy00 = g_plant
                        AND vzy12 IS NOT NULL)
        #TQC-990134-------mod--------str--------
    DISPLAY BY NAME g_vob01,g_vob02
  #FUN-930118  ADD  --END--

   INITIALIZE g_pmk.* TO NULL
   INITIALIZE g_pmk.* TO NULL
   SELECT MIN(smyslip) 
     INTO g_pmk.pmk01 
     FROM smy_file
    WHERE smysys = 'apm' 
      AND smykind= '1'
   LET g_t1 = g_pmk.pmk01 #TQC-860035
   LET g_pmk.pmk12  = g_user
   LET g_pmk.pmk04  = g_today #FUN-9B0089 add
   SELECT gen03 INTO g_pmk.pmk13 
     FROM gen_file 
    WHERE gen01 = g_pmk.pmk12
   LET summary_flag = '1'
   LET mxno         = 20
   WHILE TRUE 

   #FUN-870010 add ima43,ima67
   #CONSTRUCT BY NAME g_wc ON vob15,vob35,ima43,ima67  #FUN-930118 MARK
   CONSTRUCT BY NAME g_wc ON vob15,vob35,ima43,ima67,vob07,vob17,vob14  #FUN-930118 ADD
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
      
      #FUN-930118  MARK  --STR--
      ##FUN-880010---add----begin---
      #AFTER FIELD ima43
      #   LET g_ima43 = GET_FLDBUF(ima43)
      #   IF NOT cl_null(g_ima43) THEN
      #      SELECT * FROM gen_file
      #        WHERE gen01=g_ima43
      #          and genacti='Y'
      #      IF SQLCA.sqlcode THEN
      #         CALL cl_err3("sel","gen_file",g_ima43,"","mfg1312","","",0)
      #         DISPLAY BY NAME g_ima43
      #         NEXT FIELD ima43
      #      END IF
      #   END IF
      #
      #AFTER FIELD ima67
      #   LET g_ima67 = GET_FLDBUF(ima67)
      #   IF NOT cl_null(g_ima67) THEN
      #      SELECT * FROM gen_file
      #        WHERE gen01=g_ima67
      #          and genacti='Y'
      #      IF SQLCA.sqlcode THEN
      #         CALL cl_err3("sel","gen_file",g_ima67,"","mfg1312","","",0)
      #         DISPLAY BY NAME g_ima67
      #         NEXT FIELD ima67
      #      END IF
      #   END IF
      ##FUN-880010-----add----end---
      #FUN-930118  MARK   --END--
      ON ACTION locale
         LET g_change_lang = TRUE       
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

 
      #FUN-870010
      ON ACTION CONTROLP
         CASE   WHEN INFIELD(ima43) #主要採購員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_ima.ima43
                  CALL cl_create_qry() RETURNING g_ima.ima43
                  DISPLAY BY NAME g_ima.ima43
                  NEXT FIELD ima43
                WHEN INFIELD(ima67) #計劃員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_ima.ima67
                  CALL cl_create_qry() RETURNING g_ima.ima67
                  DISPLAY BY NAME g_ima.ima67
                  NEXT FIELD ima67
                #FUN-930118  ADD  --STR------------------
                WHEN INFIELD(vob07) #item
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_ima18"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO vob07
                  NEXT FIELD vob07
                #FUN-930118  ADD  --END------------------


         END CASE

      ON ACTION qbe_select
         CALL cl_qbe_select()


   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()    
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p810
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
      EXIT PROGRAM
   END IF
   LET g_bgjob = 'N' 
  #FUN-9B0089---mod---str---
  #add pmk04
  #INPUT g_vob01,g_vob02,g_pmk.pmk01,g_pmk.pmk12,g_pmk.pmk13,summary_flag,mxno WITHOUT DEFAULTS  
  # FROM vob01,vob02,pmk01,pmk12,pmk13,summary_flag,mxno
   INPUT g_vob01,g_vob02,g_pmk.pmk01,g_pmk.pmk04,g_pmk.pmk12,g_pmk.pmk13,summary_flag,mxno WITHOUT DEFAULTS  
    FROM vob01,vob02,pmk01,pmk04,pmk12,pmk13,summary_flag,mxno
  #FUN-9B0089---mod---end---
                 
      AFTER FIELD pmk01
         IF g_pmk.pmk01 IS NULL THEN
            NEXT FIELD pmk01
         END IF
         LET g_t1=s_get_doc_no(g_pmk.pmk01)
         CALL s_check_no("apm",g_pmk.pmk01,"","1","","","")
              RETURNING li_result,g_pmk.pmk01
         DISPLAY BY NAME g_pmk.pmk01
         IF (NOT li_result) THEN
              NEXT FIELD pmk01
         END IF

         SELECT smyapr,smysign,smydays,smyprit,smydmy4
           INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit,g_smydmy4
           FROM smy_file WHERE smyslip=g_t1
         IF STATUS THEN 
            LET g_pmkmksg = 'N'
            LET g_pmksign = ''
            LET g_pmkdays = 0
            LET g_pmkprit = ''
         END IF 
         IF cl_null(g_pmkmksg) THEN
            LET g_pmkmksg = 'N' 
         END IF 

      AFTER FIELD pmk12
         IF cl_null(g_pmk.pmk12) THEN
            NEXT FIELD pmk12
         END IF
         SELECT gen02,gen03 INTO l_gen02,l_gen03
           FROM gen_file   WHERE gen01 = g_pmk.pmk12
            AND genacti = 'Y'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","gen_file",g_pmk.pmk12,"","mfg1312","","",0)  
            DISPLAY BY NAME g_pmk.pmk13 
            NEXT FIELD pmk12
         END IF

      BEFORE FIELD pmk13
         IF cl_null(g_pmk.pmk13) THEN
            LET g_pmk.pmk13 = l_gen03
         END IF

      AFTER FIELD pmk13
         IF cl_null(g_pmk.pmk13)  THEN
            NEXT FIELD pmk13
         END IF
         SELECT gem02 INTO l_gem02
           FROM gem_file  WHERE gem01 = g_pmk.pmk13
            AND gemacti = 'Y'
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","gem_file",g_pmk.pmk13,"","mfg3097","","",0)  
            DISPLAY BY NAME g_pmk.pmk13 
            NEXT FIELD pmk13
         END IF

       AFTER FIELD mxno
          IF NOT cl_null(mxno) THEN
              IF mxno <= 0  THEN
                  #本欄位不可小於等於零
                  CALL cl_err('','aic-054',1)
                  LET mxno = 20
                  DISPLAY BY NAME mxno
                  NEXT FIELD mxno
              END IF
          END IF

         ON ACTION CONTROLP
            CASE WHEN INFIELD(vob01)
                  #FUN-930118  MARK  --STR--
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_vob02"
                  #LET g_qryparam.default1 = g_vob01
                  #LET g_qryparam.arg1     = g_plant CLIPPED
                  #CALL cl_create_qry() RETURNING g_vob01,g_vob02
                  #DISPLAY BY NAME g_vob01,g_vob02
                  #FUN-930118  MARK  --END--

                  #FUN-930118  ADD  --STR--
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     = "q_vzy05"
                    LET g_qryparam.arg1     = g_plant CLIPPED
                    CALL cl_create_qry() RETURNING g_vob01
                    LET  g_vob02 = NULL 
                   #TQC-990134---mod----str----
                   #SELECT vzy02 INTO g_vob02
                   #FROM vzy_file,
                   #     (SELECT vzy00 mvzy00,vzy01 mvzy01,max(vzy12) mvzy12  
                   #        FROM vzy_file
                   #        WHERE vzy00 = g_plant
                   #          AND vzy01 = g_vob01
                   #          AND vzy12 IS NOT NULL
                   #          AND(vzy10 IS NULL)
                   #        GROUP BY vzy00,vzy01)  mvzy_file
                   #WHERE vzy00 = mvzy00 
                   #  AND vzy01 = mvzy01
                   #  AND vzy12 = mvzy12
                   #  AND vzy00 = g_plant
                   #  AND (vzy10 IS NULL)
                    SELECT vzy02 INTO g_vob02
                      FROM vzy_file
                     WHERE vzy00 = g_plant
                       AND vzy01 = g_vob01
                       AND vzy10 IS NULL
                       AND vzy12 = (SELECT max(vzy12) FROM vzy_file
                                     WHERE vzy00 = g_plant
                                       AND vzy01 = g_vob01
                                       AND vzy10 IS NULL
                                       AND vzy12 IS NOT NULL)
                   #TQC-990134---mod----end----
                  #FUN-930118  ADD  --END--  
                  NEXT FIELD vob01


               WHEN INFIELD(pmk01) #order nubmer
                  LET g_t1=s_get_doc_no(g_pmk.pmk01)           
                  CALL q_smy(FALSE,FALSE,g_t1,'APM','1') RETURNING g_t1 
                  LET g_pmk.pmk01=g_t1                         
                  DISPLAY BY NAME g_pmk.pmk01 
                  NEXT FIELD pmk01
               WHEN INFIELD(pmk12) #請購員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_pmk.pmk12
                  CALL cl_create_qry() RETURNING g_pmk.pmk12
                  DISPLAY BY NAME g_pmk.pmk12 
                  NEXT FIELD pmk12

               WHEN INFIELD(pmk13) #請購Dept
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_pmk.pmk13
                  CALL cl_create_qry() RETURNING g_pmk.pmk13
                  DISPLAY BY NAME g_pmk.pmk13 
                  NEXT FIELD pmk13
               OTHERWISE
                  EXIT CASE
            END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
   
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
      CLOSE WINDOW p810
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apsp810"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apsp810','9031',1)      
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",g_pmk.pmk01 CLIPPED,"'",
                      " '",g_pmk.pmk12 CLIPPED,"'",
                      " '",g_pmk.pmk13 CLIPPED,"'",
                      " '",summary_flag CLIPPED,"'",
                      " '",mxno CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apsp810',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p810
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION

FUNCTION p810()
   DEFINE l_vob	          RECORD LIKE vob_file.*
   DEFINE l_name	  LIKE type_file.chr20   
   DEFINE l_str           LIKE type_file.num5  
   DEFINE l_i,l_cnt       LIKE type_file.num5 
   DEFINE l_ima06         LIKE ima_file.ima06
   DEFINE l_order         LIKE ima_file.ima06
   DEFINE l_pml20         LIKE pml_file.pml20
   DEFINE l_pml35         LIKE pml_file.pml35 #TQC-8B0040 mark   #FUN-930086 unmark
   DEFINE l_pml34         LIKE pml_file.pml34 #TQC-8B0040 add

  #LET g_sql = "SELECT vob_file.* ,ima06,pml20,pml35 FROM vob_file,vob_tmp,OUTER ima_file", #TQC-8B0040 mark
  #LET g_sql = "SELECT vob_file.* ,ima06,pml20,pml34 FROM vob_file,vob_tmp,OUTER ima_file", #TQC-8B0040 add  #FUN-930086 MARK
   LET g_sql = "SELECT vob_file.* ,ima06,pml20,pml34,pml35 FROM vob_file,vob_tmp,OUTER ima_file",  #FUN-930086 ADD
               " WHERE vob_file.vob00 = vob_tmp.vob00 ",
               "   AND vob_file.vob01 = vob_tmp.vob01 ",
               "   AND vob_file.vob02 = vob_tmp.vob02 ",
               "   AND vob_file.vob03 = vob_tmp.vob03 ",
               "   AND vob07 = ima_file.ima01 "
            
   PREPARE p810_p FROM g_sql
   DECLARE p810_c CURSOR FOR p810_p
   CALL cl_outnam('apsp810') RETURNING l_name
  #SELECT sma115 INTO g_sma115 FROM sma_file   
  #IF g_sma115 = 'Y' THEN
  #   LET g_zaa[38].zaa06 = 'N'
  #ELSE
  #   LET g_zaa[38].zaa06 = 'Y'
  #END IF
   CALL cl_prt_pos_len() 
   START REPORT p810_rep TO l_name
  #FOREACH p810_c INTO l_vob.*,l_ima06,l_pml20,l_pml35 #TQC-8B0040 mark
  #FOREACH p810_c INTO l_vob.*,l_ima06,l_pml20,l_pml34 #TQC-8B0040 add  #FUN-930086 MARK
   FOREACH p810_c INTO l_vob.*,l_ima06,l_pml20,l_pml34,l_pml35  #FUN-930086 ADD
     #LET g_pmk.pmk04 = l_vob.vob15      #請購日期 #FUN-9B0089 mark
      CALL p810_pmk_default(l_vob.vob10)
      CASE 
         WHEN summary_flag = '1'
               LET l_order = l_ima06     #料分群碼
         WHEN summary_flag = '2'
               LET l_order = l_vob.vob10 #主要供應商
         OTHERWISE   
               LET l_order = ' '
      END CASE
     #OUTPUT TO REPORT p810_rep(l_order,l_vob.*,l_pml20,l_pml35) #TQC-8B0040 mark 
     #OUTPUT TO REPORT p810_rep(l_order,l_vob.*,l_pml20,l_pml34) #TQC-8B0040 add  #FUN-930086 MARK
      OUTPUT TO REPORT p810_rep(l_order,l_vob.*,l_pml20,l_pml34,l_pml35)  #FUN-930086 ADD
   END FOREACH
   FINISH REPORT p810_rep
   CALL cl_prt(l_name,' ','1',g_len)  
   CALL cl_getmsg('amr-077',g_lang) RETURNING g_msg  
   IF cl_prompt(16,10,g_msg) THEN 
      LET g_success='Y'
   ELSE
      LET g_success='N'
   END IF
   CLOSE WINDOW p810_sure_w
END FUNCTION

#REPORT p810_rep(l_order,l_vob,l_pml20,l_pml34) #TQC-8B0040 l_pml35改為l_pml34 #FUN-930086 MARK
REPORT p810_rep(l_order,l_vob,l_pml20,l_pml34,l_pml35)   #FUN-930086 ADD 
  DEFINE l_vob	        RECORD LIKE vob_file.*
  DEFINE l_order	LIKE ima_file.ima43 
  DEFINE l_ima49        LIKE ima_file.ima49
  DEFINE l_ima491       LIKE ima_file.ima491
  DEFINE l_date         LIKE type_file.dat 
  DEFINE l_pml80        STRING
  DEFINE l_pml82        STRING
  DEFINE l_pml83        STRING
  DEFINE l_pml85        STRING
  DEFINE l_pml20        LIKE pml_file.pml20
  DEFINE l_pml35        LIKE pml_file.pml35 #TQC-8B0040 mark  #FUN-930086 unmark
  DEFINE l_pml34        LIKE pml_file.pml34 #TQC-8B0040 add
  DEFINE l_ima44        LIKE ima_file.ima44
  DEFINE l_ima25        LIKE ima_file.ima25
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_ima907       LIKE ima_file.ima907
  DEFINE l_cnt          LIKE type_file.num5    
  DEFINE l_factor       LIKE ima_file.ima44_fac
  DEFINE l_str2         LIKE zaa_file.zaa08 
 #DEFINE l_pmli         RECORD LIKE pmli_file.*  #TQC-990134

  OUTPUT TOP MARGIN    g_top_margin 
         LEFT MARGIN   g_left_margin
         BOTTOM MARGIN g_bottom_margin 
         PAGE LENGTH   g_page_line   

  ORDER EXTERNAL BY l_order, l_vob.vob07, l_vob.vob15
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED       
      PRINT g_dash1

    BEFORE GROUP OF l_order
      CALL ins_pmk()
      PRINT
      PRINT COLUMN g_c[31],g_pmk01,             
            COLUMN g_c[32],l_order[1,6];

    ON EVERY ROW
      IF cl_null(mxno) THEN
          LET mxno = g_max_rec
      END IF
      IF g_pml.pml02 >= mxno THEN
         CALL ins_pmk()
         PRINT
         PRINT COLUMN g_c[31],g_pmk01,          
               COLUMN g_c[32],l_order[1,6];
      END IF
      LET g_pml.pml02 = g_pml.pml02 + 1
      IF g_bgjob = 'N' THEN 
          MESSAGE 'ins pml:',g_pml.pml01,' ',g_pml.pml02
      END IF
      LET g_pml.pml04  = l_vob.vob07
      LET g_pml.pml041 = NULL
      LET g_pml.pml07  = NULL
      LET g_pml.pml08  = NULL
      LET g_pml.pml09  = 1
      SELECT ima02,ima39,ima44,ima25,ima44_fac,ima913,ima914   
        INTO g_pml.pml041,g_pml.pml40,g_pml.pml07,g_pml.pml08,g_pml.pml09,
             g_pml.pml190,g_pml.pml191   
        FROM ima_file 
       WHERE ima01=g_pml.pml04
      #FUN-B80077---add---str---
      IF g_pml.pml07 <> g_pml.pml08 THEN
          CALL s_umfchk(g_pml.pml04,g_pml.pml07,
                        g_pml.pml08) RETURNING l_cnt,g_pml.pml09
          IF l_cnt THEN
              LET g_pml.pml09 = 1
          END IF
      ELSE
          LET g_pml.pml09  = 1
      END IF
      #FUN-B80077---add---end---
      LET g_pml.pml192 = "N"   
      IF g_pml.pml07 != g_pml.pml08 THEN 
          LET l_vob.vob08 = l_vob.vob08 / g_pml.pml09
      END IF 
      LET g_pml.pml11 ='N'
      LET g_pml.pml13 =g_sma.sma401
      LET g_pml.pml14 =g_sma.sma886[1,1]         #部份交貨
      LET g_pml.pml15 =g_sma.sma886[2,2]         #提前交貨

     #FUN-9A0079 add str--------------
      IF g_pmkmksg = 'Y' THEN
         LET g_pml.pml16 = '0'
      ELSE
     #FUN-9A0079 add end--------------
         IF g_smydmy4='Y' THEN    #立即確認
            LET g_pml.pml16='1'
         ELSE
            LET g_pml.pml16='0'
         END IF
      END IF                       #FUN-9A0079 add
      LET g_pml.pml20 = l_pml20
      LET g_pml.pml20 = s_digqty(g_pml.pml20,g_pml.pml07)   #FUN-910088--add--
      LET g_pml.pml21 = 0
     #FUN-D10086---mod---str---
     #LET g_pml.pml30 = 0
     #來源料件/供廠商對應檔的預設值(標準價格)
      SELECT imb118 
        INTO g_pml.pml30 
        FROM imb_file
       WHERE imb01 = g_pml.pml04
      IF cl_null(g_pml.pml30) THEN 
          LET g_pml.pml30 = 0
      END IF
     #FUN-D10086---mod---end---
      LET g_pml.pml31 = 0
      LET g_pml.pml32 = 0
#------------------------------------------------------mandy??
      SELECT ima49,ima491 INTO l_ima49,l_ima491
       FROM ima_file WHERE ima01=g_pml.pml04
      IF cl_null(l_ima49) THEN LET l_ima49=0 END IF
      IF cl_null(l_ima491) THEN LET l_ima491=0 END IF
     #TQC-8B0040 mod---str---
     #LET g_pml.pml35 = l_pml35                                  #到庫日
     #CALL s_aday(g_pml.pml35,-1,l_ima491) RETURNING g_pml.pml34 #到廠日  
      LET g_pml.pml34 = l_pml34                                  #到廠日
      #到庫日 = 到廠日 + 入庫前置期   
      #CALL s_aday(g_pml.pml34,1,l_ima491) RETURNING g_pml.pml35  #到庫日 #FUN-930086 MARK 
      LET g_pml.pml35 = l_pml35      #FUN-930086 ADD
     #TQC-8B0040 mod---end---
      #交貨日 = 到廠日 - 到廠前置期 
      CALL s_aday(g_pml.pml34,-1,l_ima49)  RETURNING g_pml.pml33 #交貨日
      #FUN-CC0075(2)---add----str---
      IF g_pml.pml33 < g_today THEN
          LET g_pml.pml33 = l_vob.vob15
          IF g_pml.pml33 < g_today THEN
              LET g_pml.pml33 = g_today
          END IF
      END IF
      #FUN-CC0075(2)---add----end---
      LET g_pml.pml38 = 'Y'
      LET g_pml.pml42 = '0'
      LET g_pml.pml44 = 0
      LET g_pml.pml05 = l_vob.vob03
      IF g_sma.sma115 = 'Y' THEN
         SELECT   ima25,  ima44,  ima906,  ima907 
           INTO l_ima25,l_ima44,l_ima906,l_ima907
           FROM ima_file 
          WHERE ima01=g_pml.pml04
         IF SQLCA.sqlcode = 100 THEN                                                  
            IF g_pml.pml04 MATCHES 'MISC*' THEN                                
               SELECT ima25  ,  ima44,  ima906,  ima907
                 INTO l_ima25,l_ima44,l_ima906,l_ima907
                 FROM ima_file 
                WHERE ima01 = 'MISC'                                    
            END IF                                                                   
         END IF                                                                      
         IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
         LET g_pml.pml80=g_pml.pml07
         LET l_factor = 1
         CALL s_umfchk(g_pml.pml04,g_pml.pml80,l_ima44) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml.pml81 = l_factor
         LET g_pml.pml82 = g_pml.pml20
         LET g_pml.pml83 = l_ima907
         LET l_factor = 1
         CALL s_umfchk(g_pml.pml04,g_pml.pml83,l_ima44) 
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml.pml84 = l_factor
         LET g_pml.pml85 = 0
         IF l_ima906 = '3' THEN
            LET l_factor = 1
            CALL s_umfchk(g_pml.pml04,g_pml.pml80,g_pml.pml83) 
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET g_pml.pml85 = g_pml.pml82*l_factor
            LET g_pml.pml85 = s_digqty(g_pml.pml85,g_pml.pml83)   #FUN-910088--add--
         END IF
      END IF
      LET g_pml.pml86 = g_pml.pml07
      LET g_pml.pml87 = g_pml.pml20
      SELECT ima906 INTO l_ima906 
        FROM ima_file                                                                     
       WHERE ima01=g_pml.pml04                                                                                      
      LET l_str2 = ""                                                                                                               
      IF g_sma115 = "Y" THEN                                                                                                        
         CASE l_ima906                                                                                                              
            WHEN "2"                                                                                                                
                CALL cl_remove_zero(g_pml.pml85) RETURNING l_pml85                                                                     
                LET l_str2 = l_pml85 , g_pml.pml83 CLIPPED                                                                             
                IF cl_null(g_pml.pml85) OR g_pml.pml85 = 0 THEN                                                                           
                    CALL cl_remove_zero(g_pml.pml82) RETURNING l_pml82                                                                 
                    LET l_str2 = l_pml82, g_pml.pml80 CLIPPED                                                                          
                ELSE                                                                                                                
                   IF NOT cl_null(g_pml.pml82) AND g_pml.pml82 > 0 THEN                                                                   
                      CALL cl_remove_zero(g_pml.pml82) RETURNING l_pml82                                                               
                      LET l_str2 = l_str2 CLIPPED,',',l_pml82, g_pml.pml80 CLIPPED                                                     
                   END IF                                                                                                           
                END IF   
            WHEN "3"                                                                                                                
                IF NOT cl_null(g_pml.pml85) AND g_pml.pml85 > 0 THEN                                                                      
                    CALL cl_remove_zero(g_pml.pml85) RETURNING l_pml85                                                                 
                    LET l_str2 = l_pml85 , g_pml.pml83 CLIPPED                                                                         
                END IF                                                                                                              
         END CASE                                                                                                                   
      ELSE                                                                                                                          
      END IF                 
      #FUN-D10086---add----str---
      LET g_pml.pml23 = 'Y'          #課稅否
      LET g_pml.pml67 = g_pmk.pmk13  #部門編號  (For 請採購預算)  
      LET g_pml.pml18 = NULL         #MRP 需求日期
      #FUN-D10086---add----end---
      PRINT COLUMN g_c[33],g_pml.pml05,        
            COLUMN g_c[34],g_pml.pml02 USING '####',
            COLUMN g_c[35],g_pml.pml04[1,18],
            COLUMN g_c[36],g_pml.pml041,
            COLUMN g_c[37],g_pml.pml07,
            COLUMN g_c[38],l_str2 CLIPPED,    
            COLUMN g_c[39],cl_numfor(g_pml.pml20,39,g_azi03), 
           #COLUMN g_c[40],g_pml.pml33 #TQC-8B0040 mark
            COLUMN g_c[40],g_pml.pml34 #TQC-8B0040 mod
      LET g_pml.pml930=s_costcenter(g_pmk.pmk13) 
      LET g_pml.pml25 = NULL
      #FUN-B50022---add----str----
      LET g_pml.pml49='1' #No.FUN-870007
      LET g_pml.pml50='1' #No.FUN-870007
      LET g_pml.pml54='2' #No.FUN-870007
      LET g_pml.pml56='1' #No.FUN-870007
      LET g_pml.pmlplant = g_plant #FUN-980006
      LET g_pml.pmllegal = g_legal #FUN-980006
      LET g_pml.pml92 = 'N' #FUN-9B0023
      LET g_pml.pml91 = 'N' 
      #FUN-B50022---add----end----
      INSERT INTO pml_file VALUES(g_pml.*)
      IF STATUS THEN
         CALL cl_err3("ins","pml_file",g_pml.pml01,g_pml.pml02,STATUS,"","ins pml:",1)  
         IF g_bgjob = 'Y' THEN CALL cl_batch_bg_javamail("N") END IF  
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
         EXIT PROGRAM 
      END IF
     #TQC-990134---mark---str----
     ##NO.FUN-7B0018 08/01/31 add --begin
     #IF NOT s_industry('std') THEN
     #   INITIALIZE l_pmli.* TO NULL
     #   LET l_pmli.pmli01 = g_pml.pml01
     #   LET l_pmli.pmli02 = g_pml.pml02
     #   IF NOT s_ins_pmli(l_pmli.*,'') THEN
     #      LET g_success='N'
     #      IF g_bgjob = 'Y' THEN
     #         CALL cl_batch_bg_javamail("N") 
     #      END IF  
     #      EXIT PROGRAM 
     #   END IF
     #END IF
     ##NO.FUN-7B0018 08/01/31 add --end
     #TQC-990134---mark---end----
     #CALL p810_upd_vob(l_vob.*,g_pml.pml20,g_pml.pml35,g_pmk01) #FUN-870013 add #TQC-8B0040 mark
     #CALL p810_upd_vob(l_vob.*,g_pml.pml20,g_pml.pml34,g_pmk01) #FUN-870013 add #TQC-8B0040 add  #FUN-930086 MARK
      CALL p810_upd_vob(l_vob.*,g_pml.pml20,g_pml.pml34,g_pmk01,g_pml.pml35)  #FUN-930086 ADD
      ON LAST ROW                                                                                                                   
         PRINT g_dash[1,g_len]                                                                                                      
         PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED                                                                  
                                                                                                                                    
      PAGE TRAILER                                                                                                                  
            PRINT g_dash[1,g_len]                                                                                                   
            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED                                                               
END REPORT

FUNCTION p810_pmk_default(p_ima54)
      DEFINE  p_ima54   LIKE    ima_file.ima54

      LET g_pmk.pmk02 = 'REG'
      LET g_pmk.pmk03 = 0
      IF p_ima54 <> 'UNDEF' THEN #FUN-870013 add if 判斷
          LET g_pmk.pmk09 = p_ima54
          IF NOT cl_null(p_ima54) THEN
              SELECT pmc17      ,pmc49      ,pmc15      ,pmc16      ,pmc47      ,pmc22 
                INTO g_pmk.pmk20,g_pmk.pmk41,g_pmk.pmk10,g_pmk.pmk11,g_pmk.pmk21,g_pmk.pmk22
                FROM pmc_file
               WHERE pmc01 = p_ima54
          END IF
      ELSE
          LET g_pmk.pmk09 = NULL
      END IF

     #FUN-9A0079 add str--------------
      IF g_pmkmksg = 'Y' THEN     
         LET g_pmk.pmk18 = 'N'
         LET g_pmk.pmk25 = '0'
      ELSE
     #FUN-9A0079 add end--------------
         IF g_smydmy4 = 'Y' THEN  #立即確認
            LET g_pmk.pmk18 = 'Y'
            LET g_pmk.pmk25 = '1'
         ELSE
            LET g_pmk.pmk18 = 'N'
            LET g_pmk.pmk25 = '0'
         END IF
      END IF                       #FUN-9A0079 add

      LET g_pmk.pmk27   = g_today
      LET g_pmk.pmk30   = 'Y'
      LET g_pmk.pmk31   = YEAR(g_pmk.pmk04)
      LET g_pmk.pmk32   = MONTH(g_pmk.pmk04)
      LET g_pmk.pmk40   = 0
      LET g_pmk.pmk401  = 0
     #FUN-990096---mod---str----
     #LET g_pmk.pmk42   = 1
      IF g_aza.aza17 = g_pmk.pmk22 THEN   #本幣
         LET g_pmk.pmk42 = 1
      ELSE 
        #FUN-BB0103 add str---
         IF cl_null(g_pmk.pmk22) THEN
            LET g_pmk.pmk42 = 1
         ELSE
        #FUN-BB0103 add end---
            CALL s_curr3(g_pmk.pmk22,g_pmk.pmk04,g_sma.sma904) 
            RETURNING g_pmk.pmk42
         END IF  #FUN-BB0103
      END IF
     #FUN-990096---mod---end----
     #LET g_pmk.pmk43   = 0  #FUN-B50022 mark
     #FUN-B50022---add---str---
      CALL p810_pmk21()     
      IF cl_null(g_pmk.pmk43) THEN
          LET g_pmk.pmk43 = 0
      END IF
     #FUN-B50022---add---end---
      LET g_pmk.pmk45   = 'Y'
      LET g_pmk.pmkprsw = 'Y'
      LET g_pmk.pmkprno = 0
      LET g_pmk.pmksmax = 0         #己簽順序 #FUN-B50022 add
      LET g_pmk.pmksseq = 0         #應簽順序 #FUN-B50022 add
      #FUN-870013--add---str---
      SELECT smyapr,smysign,smydays,smyprit,smydmy4
        INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit,g_smydmy4
        FROM smy_file WHERE smyslip=g_t1
      IF STATUS THEN 
         LET g_pmkmksg = 'N'
         LET g_pmksign = ''
         LET g_pmkdays = 0
         LET g_pmkprit = ''
      END IF 
      IF cl_null(g_pmkmksg) THEN
         LET g_pmkmksg = 'N' 
      END IF 
      #FUN-870013--add---str---
      LET g_pmk.pmkmksg = g_pmkmksg  
      LET g_pmk.pmksign = g_pmksign  
      LET g_pmk.pmkdays = g_pmkdays  
      IF cl_null(g_pmk.pmkdays) THEN LET g_pmk.pmkdays = 0 END IF        #簽核天數 #FUN-B50022 add
      LET g_pmk.pmkprit = g_pmkprit  
      LET g_pmk.pmkacti = 'Y'
      LET g_pmk.pmkuser = g_user
      LET g_pmk.pmkgrup = g_grup
      LET g_pmk.pmkdate = g_today
      LET g_pmk.pmk47 = g_plant  #FUN-B50022 add
      LET g_pmk.pmk48 = TIME     #FUN-B50022 add
      LET g_pmk.pmkcrat = g_today #資料創建日 #FUN-B50022 add
END FUNCTION

FUNCTION ins_pmk()
  DEFINE li_result   LIKE type_file.num5             
      CALL s_auto_assign_no("apm",g_pmk.pmk01,g_pmk.pmk04,"1","pmk_file","pmk01",
           "","","")
      RETURNING li_result,g_pmk.pmk01
      IF (NOT li_result) THEN
         LET g_success='N' 
         IF g_bgjob = 'Y' THEN CALL cl_batch_bg_javamail("N") END IF  
         CALL cl_err('','asf-377',1) #自動編號錯誤, 無法繼續執行!! #TQC-860035 add
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B50022 add
         EXIT PROGRAM 
      END IF
      IF g_bgjob = 'N' THEN  
          MESSAGE 'ins pmk:',g_pmk.pmk01
      END IF
      #FUN-B50022---add----str---
      LET g_pmk.pmk46='1' #No.FUN-870007
      LET g_pmk.pmkplant = g_plant #FUN-980006
      LET g_pmk.pmklegal = g_legal #FUN-980006
      LET g_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
      LET g_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
      #FUN-B50022---add----end---
      INSERT INTO pmk_file VALUES(g_pmk.*)
      IF STATUS THEN 
          CALL cl_err3("ins","pmk_file",g_pmk.pmk01,"",STATUS,"","INS PMK:",1)  
          IF g_bgjob = 'Y' THEN 
              CALL cl_batch_bg_javamail("N") 
          END IF  
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
          EXIT PROGRAM 
      END IF
      LET g_pml.pml01  = g_pmk.pmk01
      LET g_pml.pml011 = g_pmk.pmk02
      LET g_pml.pml02  = 0
      LET g_pmk01      = g_pmk.pmk01      
      LET g_pmk.pmk01  = g_t1            
END FUNCTION

FUNCTION p810_b_fill()                 #單身填充
    DEFINE #l_sql      LIKE type_file.chr1000
           l_sql        STRING       #NO.FUN-910082  
    DEFINE l_factor   LIKE vob_file.vob26  #FUN-870013 add
    DEFINE l_cnt      LIKE type_file.num5  #FUN-870013 add

       #FUN-870010 add buyer,planner
       #LET l_sql = "SELECT 'Y',vob10,pmc03,ima43 buyer,ima67 planner,vob07,ima02,ima021,vob11,vob25,'',vob15,'',vob14,vob33,'',vob14,vob03 ", #FUN-870013 mod  #FUN-930086 MARK
       #LET l_sql = "SELECT 'Y',vob10,pmc03,ima43 buyer,ima67 planner,vob07,ima02,ima021,vob11,vob25,'',vob15,'',vob14,vob14,vob33,'',vob14,vob40,vob03 ",  #FUN-930086 add  #FUN-930118 MARK
       #LET l_sql = "SELECT 'Y',vob10,pmc03,ima43 buyer,ima67 planner,vob07,ima02,ima021,vob11,vob25,'',vob15,'',vob14,vob14,vob33,'',vob14,vob40,vob03,vob17,vob42 ",        #FUN-930118 ADD  #FUN-9B0090 mark
       #LET l_sql = "SELECT 'Y',vob10,pmc03,ima43 buyer,ima67 planner,vob07,ima02,ima021,vob11,vob25,'',vob15,vob08,'',vob14,vob14,vob33,'',vob14,vob40,vob03,vob17,vob42 ",  #FUN-930118 ADD  #FUN-9B0090 add  #FUN-CC0075(1) mark
        LET l_sql = "SELECT 'Y',vob10,pmc03,ima43 buyer,ima67 planner,vob07,ima02,ima021,vob11,vob25,'',vob15,vob08,'',vob14,vob40,vob33,'',vob14,vob40,vob03,vob17,vob42 ",  #FUN-930118 ADD  #FUN-9B0090 add  #FUN-CC0075(1) add
                   "  FROM vob_file,OUTER ima_file,OUTER pmc_file ",
                   " WHERE vob00 = '",g_plant,"'",
                   "   AND vob01 = '",g_vob01,"'",
                   "   AND vob02 = '",g_vob02,"'",
                   "   AND vob24 = 0 ", #0:建議請購
                   "   AND vob05 = 1 ", #TQC-880040 add
                   "   AND (vob36 = 'N' ",   #未拋轉至請購單的才能產生 #FUN-870013 add 
                   "    OR vob36 IS NULL OR vob36 = ' ') ", #TQC-870030 add 因為 APS並不會給vob36值
                   "   AND vob07 = ima_file.ima01 ",
                   "   AND vob10 = pmc_file.pmc01 ",
                   "   AND ",g_wc CLIPPED
       PREPARE p810_prepare FROM l_sql
       MESSAGE " SEARCHING! " 
       DECLARE p810_cur CURSOR FOR p810_prepare
       CALL g_vob.clear()
       LET g_cnt = 1

       FOREACH p810_cur INTO g_vob[g_cnt].*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
         #SELECT ima02,ima021 INTO g_vob[g_cnt].ima02,g_vob[g_cnt].ima021
         #  FROM ima_file
         # WHERE ima01 = g_vob[g_cnt].vob07
          #FUN-870013---add----str---
            LET l_factor = 1
            #採購/庫存單位換算率
            CALL s_umfchk(g_vob[g_cnt].vob07,g_vob[g_cnt].vob25,g_vob[g_cnt].vob11) 
                 RETURNING l_cnt,l_factor
            IF l_cnt = 1 THEN
               LET l_factor = 1
            END IF
            LET g_vob[g_cnt].vob26    = l_factor
           #FUN-9A0028---mod---str----
           #vob33的量,已是用採購數量來看,不需要再*單位換算率
           #LET g_vob[g_cnt].pml20    = g_vob[g_cnt].vob33 * l_factor
           #LET g_vob[g_cnt].vob33_po = g_vob[g_cnt].vob33 * l_factor
            LET g_vob[g_cnt].pml20    = g_vob[g_cnt].vob33
            LET g_vob[g_cnt].vob33_po = g_vob[g_cnt].vob33
           #FUN-9A0028---mod---end----
          #FUN-870013---add----end---

          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
       CALL g_vob.deleteElement(g_cnt)
       LET g_cnt = g_cnt - 1
       DISPLAY g_cnt TO FORMONLY.cnt2  
       LET g_rec_b = g_cnt 
END FUNCTION

FUNCTION p810_b()                          #單身修改
DEFINE
    l_pmc03         LIKE pmc_file.pmc03,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_i             LIKE type_file.num5,   
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,    #檢查重複用        
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        
    p_cmd           LIKE type_file.chr1,    #處理狀態          
    l_total         LIKE alh_file.alh33,    #
    l_allow_insert  LIKE type_file.num5,    #可新增否          
    l_allow_delete  LIKE type_file.num5     #可刪除否          

    LET g_action_choice = ""
    CALL cl_opmsg('b')
 
   #LET g_forupd_sql = "SELECT vob10,vob07,vob11,vob25,vob15,vob33,vob14,vob03 ",       #FUN-870013 mod #FUN-9B0090 mark
    LET g_forupd_sql = "SELECT vob10,vob07,vob11,vob25,vob15,vob08,vob33,vob14,vob03 ", #FUN-870013 mod #FUN-9B0090 add
                       "  FROM vob_file ",
                       " WHERE vob00 = '",g_plant,"'",
                       "   AND vob01 = '",g_vob01,"'",
                       "   AND vob02 = '",g_vob02,"'",
                       "   AND vob03 = ? "
    DECLARE p810_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t = 0
       #LET l_allow_insert = cl_detail_input_auth("insert")
       #LET l_allow_delete = cl_detail_input_auth("delete")
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
        INPUT ARRAY g_vob WITHOUT DEFAULTS FROM s_vob.* 
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

        BEFORE INPUT
            IF g_rec_b != 0 THEN
                LET l_ac = 1
                CALL fgl_set_arr_curr(l_ac)
            END IF

        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()

            BEGIN WORK
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'

                LET g_vob_t.* = g_vob[l_ac].*  #BACKUP
                OPEN p810_bcl USING g_vob_t.vob03

                IF STATUS THEN
                    CALL cl_err("OPEN p810_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    #FUN-870013--mod--str--
                    FETCH p810_bcl INTO g_vob[l_ac].vob10 ,g_vob[l_ac].vob07 ,
                                        g_vob[l_ac].vob11 ,g_vob[l_ac].vob25 ,
                                       #g_vob[l_ac].vob15 ,g_vob[l_ac].vob33 ,                    #FUN-9B0090 mark
                                        g_vob[l_ac].vob15 ,g_vob[l_ac].vob08 ,g_vob[l_ac].vob33 , #FUN-9B0090 add
                                        g_vob[l_ac].vob14 ,g_vob[l_ac].vob03
                    #FUN-870013--mod--end--

                END IF
                CALL cl_show_fld_cont()     
            END IF  

        BEFORE INSERT
            LET p_cmd='a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_vob[l_ac].* TO NULL      #900423
            LET g_vob_t.* = g_vob[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     
            NEXT FIELD vob02

        AFTER INSERT
          #DISPLAY "AFTER INSERT!"  #CHI-A70049 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
#              LET INT_FLAG = 0                  #TQC-780087-mark 
               IF p_cmd = 'u' THEN
                   LET g_vob[l_ac].* = g_vob_t.*
               END IF
               CLOSE p810_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p810_bcl
            COMMIT WORK

        

        ON ACTION all_yes
            FOR l_i = 1 TO g_rec_b
                LET g_vob[l_i].select = 'Y'
                DISPLAY BY NAME g_vob[l_i].select
            END FOR 

        ON ACTION all_no
            FOR l_i = 1 TO g_rec_b
                LET g_vob[l_i].select = 'N'
                DISPLAY BY NAME g_vob[l_i].select
            END FOR 

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
        
          
        ON ACTION controls                                                                                                             
           CALL cl_set_head_visible("","AUTO")                                                                                        
        END INPUT

        IF INT_FLAG THEN
           LET INT_FLAG = 0 
           RETURN 
        END IF
END FUNCTION

FUNCTION p810_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE
  DROP TABLE vob_tmp
  #FUN-B50022---mod----str---
  CREATE TEMP TABLE vob_tmp(
                           vob00   LIKE vob_file.vob00, 
                           vob01   LIKE vob_file.vob01,      #FUN-C40039 mod vob00->vob01
                           vob02   LIKE vob_file.vob02,      #FUN-C40039 mod vob00->vob02
                           vob03   LIKE vob_file.vob03,      #FUN-C40039 mod vob00->vob03
                           pml20   LIKE pml_file.pml20,
                           pml34   LIKE pml_file.pml34,      #TQC-8B0040 add
                           pml35   LIKE pml_file.pml35)      #TQC-8B0040 mark  #FUN-930086 unmark
  #FUN-B50022---mod----end---
END FUNCTION

FUNCTION p810_ins_vob_tmp()
  DEFINE l_i             LIKE type_file.num5

     FOR l_i = 1 TO g_rec_b
          IF g_vob[l_i].select = 'Y' THEN
             #INSERT INTO vob_tmp VALUES(g_plant,g_vob01,g_vob02,g_vob[l_i].vob03,g_vob[l_i].pml20,g_vob[l_i].pml35) #TQC-8B0040 mark
             #INSERT INTO vob_tmp VALUES(g_plant,g_vob01,g_vob02,g_vob[l_i].vob03,g_vob[l_i].pml20,g_vob[l_i].pml34) #TQC-8B0040 add   #FUN-930086 mark
              INSERT INTO vob_tmp VALUES(g_plant,g_vob01,g_vob02,g_vob[l_i].vob03,g_vob[l_i].pml20,g_vob[l_i].pml34,g_vob[l_i].pml35) #FUN-930086 ADD
              IF STATUS THEN 
                  CALL cl_err('Ins vob_tmp',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
                  EXIT PROGRAM 
              END IF
              LET g_select = g_select + 1
          END IF
     END FOR

END FUNCTION
#FUN-870013--add---str--
#FUNCTION p810_upd_vob(p_vob,p_pml20,p_pml34,p_pmk01) #TQC-8B0040 p_pml35改為p_pml34  #FUN-980086 MARK
FUNCTION p810_upd_vob(p_vob,p_pml20,p_pml34,p_pmk01,p_pml35)  #FUN-930086 ADD
  DEFINE p_vob	          RECORD LIKE vob_file.*
  DEFINE p_pml20          LIKE pml_file.pml20
  DEFINE p_pml35          LIKE pml_file.pml35 #TQC-8B0040 mark  #FUN-930086 unmark
  DEFINE p_pml34          LIKE pml_file.pml34 #TQC-8B0040 add
  DEFINE p_pmk01          LIKE pmk_file.pmk01

  UPDATE vob_file 
     SET vob36 = 'Y',         #拋轉否='Y' #已拋轉
         vob37 = p_pml20,     #確認請購數量
         #vob38 = p_pml35,     #確認到庫日 #TQC-8B0040 mark  
         vob40 = p_pml35,      #FUN-930086 ADD
         vob38 = p_pml34,     #確認到廠日 #TQC-8B0040 add
         vob39 = p_pmk01      #產生的請購單號
   WHERE vob00 = p_vob.vob00
     AND vob01 = p_vob.vob01
     AND vob02 = p_vob.vob02
     AND vob03 = p_vob.vob03
  IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","vob_file",p_vob.vob00,p_vob.vob01,SQLCA.sqlcode,"","upd vob_file",1) 
      LET g_success = 'N'
  END IF
END FUNCTION
#FUN-870013--add---str--

#FUN-B50022--add---str--
FUNCTION p810_pmk21()  #稅別
   DEFINE l_gec04     LIKE gec_file.gec04,
          l_gecacti   LIKE gec_file.gecacti
 
   LET g_errno = " "
 
   SELECT gec04,gecacti INTO l_gec04,l_gecacti
     FROM gec_file
    WHERE gec01 = g_pmk.pmk21
      AND gec011 = '1'  #進項
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                           LET l_gec04 = 0
        WHEN l_gecacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF NOT cl_null(l_gec04) THEN
      LET g_pmk.pmk43 = l_gec04
   END IF
 
END FUNCTION
#FUN-B50022--add---end--
