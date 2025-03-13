# Prog. Version..: '5.30.06-13.03.12(00010)'     #
# Pattern name...: apsp820.4gl 
# Descriptions...: APS 工單產生作業
# Date & Author..: 2008/04/29 By Mandy #FUN-840008
# Modify.........: TQC-860035 2008/06/23 By Mandy (1)只勾選預產生工單的料號-->確認後-->確產生全部,應該只有產生有勾選的那幾個料號
#                                                 (2)確認完之後,會跳出視窗詢問"是否確定產生工單",就算選否,工單還是已經產生了(BUG)
#                                                 (3)p820_b_fill()應該再加一個where 條件,vod08='1'(BUG)
# Modify.........: FUN-870013 2008/07/04 By Mandy 庫存/生產單位問題
# Modify.........: No:FUN-870051 08/07/16 By sherry 增加被替代料(sfa27)為Key
# Modify.........: TQC-870030 2008/07/21 By Mandy (1)無法產生apsp820明細單身資料
#                                                 (2)拋轉後產生之工單資料asfi301中訂單編號欄位為空
# Modify.........: FUN-880010 2008/08/04 By Duke (1)產生的工單是否使用製程否,依據vod39的值
#                                                (2)單頭QBE增加計劃員(ima67),是否使用製程(vod39);單身增加 計劃員(ima67),是否使用製程(vod39) 
# Modify.......... FUN-880024 2008/08/06 By Mandy (1)是否為委外工單目前是抓料件基本檔,應抓APS資料,join voo_file,有值的,表示為委外工單
#                                                 (2)選項增加工單型態為一般或委外
#                                                 (3)預測料號不能拋工單(來源碼ima08 <> 'X':不為X:虛擬料件時才拋工單)
# Modify.........: TQC-8A0014 2008/10/09 By Mandy vod20塞sfb22時,要分開塞兩個欄位,前面單號的部分塞sfb22,序號的部分要塞sfb221
# Modify.........: No:FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-930149 09/03/25 By Duke 原判斷委外check voo_file 改直接取 vod_file.vod42(0為一般工單,非0則為外包)
# Modify.........: No:FUN-930118 09/03/30 By Duke QBE增加料件,需求供給訂單,供給法則; 單身增加供給需求訂單,供給法則
# Modify.........: No:MOD-940129 09/04/09 bY DUKE p820_upd_sfa08() 增加拋轉參數vod03
# Modify.........: No:CHI-950037 09/06/22 By jan 在工單開立，產生備料時，需排除bmb14='不發料'的資料
# Modify.........: No:FUN-960107 09/07/11 By Duke 工單產生作業調整
# Modify.........: No:CHI-980013 09/08/31 By jan 當bmb14='1'時,也要產生備料
# Modify.........: No.FUN-990008 09/09/03 By Mandy 產生工單製程追蹤(aeci700)的同時,也要產生vmn_file,vnm_file
# Modify.........: No:TQC-990134 09/09/24 By Mandy SQL語法調整,因為5.0此種寫法r.c2 會err
# Modify.........: No:TQC-990134 09/09/24 By Mandy 將行業別的寫法mark
# Modify.........: No:FUN-990088 09/09/30 By Mandy 工單產生時,訂單單號+項次改紀錄在備註(sfb96)
# Modify.........: No:FUN-9A0028 09/10/13 By Mandy (1)voe12轉入sfa04及sfa05需轉成發料單位量後再存入,相關欄位資訊可mapping BOM資料(bmb29=' '),若BOM資料mapping不到,則此筆工單不產生
#                                                  (2)vod35的量,已是用生產數量來看,不需要再*單位換算率
#                                                  (3)將單身欄位vod28,vod29,vod35 隱藏
# Modify.........: No:FUN-9A0029 09/10/20 By Mandy sfb13=vod11取日期; sfb14=vod11取時間 ; sfb15=vod10取日期; sfb16=vod10取時間
# Modify.........: No.FUN-9A0047 09/10/20 By Mandy 產生vmn_file時,當製程為委外時(ecm52='Y'),則vmn18=vop07(外包商編號)
# Modify.........: No.FUN-9A0047 09/10/20 By Mandy 產生vmn_file時,當製程為委外時(ecm52='Y'),則vmn18=vop07(外包商編號)
# Modify.........: No:FUN-9A0031 09/10/27 By Mandy 條件選項應該再加一個申請人欄位,產生工單時可以塞申請人欄位(申請人為必要欄位)
# Modify.........: No:FUN-9A0089 09/10/27 By Mandy 產生工單時,不應check 製令編號(vod03)的編碼方式 ex:錯誤訊息 WO:01-M00152 <>'APS_MO*'
# Modify.........: No:FUN-9B0091 09/11/11 By Mandy (1)單身欄位加show vod04--原開立量(含虛擬耗用)
# Modify.........: No:FUN-9B0077 09/11/26 By Mandy 找BOM(abmi600)資料若找不到時,改找替代BOM(abmi6042)
# Modify.........: No:FUN-9C0011 09/12/07 By Mandy sfb100 新增工單時sfb100應給值,依smy57[6,6]
# Modify.........: No.FUN-9C0144 10/01/25 By Mandy 查詢條件有ima67,但p820_p 未用到ima_file 會造成sql錯誤
# Modify.........: No:CHI-A70049 10/07/28 By Pengu 將多餘的DISPLAY程式mark 
# Modify.........: No.TQC-A90102 10/09/21 By Mandy (1)SELECT * FROM xxx_file 後用STATUS判斷
#                                                     當SELECT 出來資料非一筆為多筆時,STATUS為-284,建議改用SELECT COUNT(*)的型式來判斷
#                                                  (2)找取替代BOM(abmi6042)資料時,加上生/失效日的判斷
# Modify.........: No:MOD-B20145 11/02/25 By Mandy 
# apsp820產生工單備料檔時,認定發料料號是為替代料的的情況,
# 要在增加以下條件:
# (1)為替代料情況: voe06(發料料號)在ERP的BOM找不到 或是 voe06(發料料號)在ERP的BOM找的到且voe06(發料料號)<>voe15(被替代料號)
# (2)不為替代料情況: voe06(發料料號)在ERP的BOM找的到且voe06(發料料號) = voe15(被替代料號)
# Modify.........: No:FUN-B30121 11/03/16 By Mandy 工單備料取替代調整
# Modify.........: No:TQC-B30159 11/03/21 By Mandy (1)成本中心可預設 s_costcenter(sfb82)
#                                                  (2)簽核否欄位值及簽核狀態需預設
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以上為GP5.1 的單號---
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版:以下為GP5.25的單號---str---
# Modify.........: No.FUN-980006 09/08/13 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/13 By vealxu 精簡程式碼
# Modify.........: No:FUN-9C0040 10/01/28 By jan,當BOM單身性質為"回收料"時,產生備料時，"實際QPA"和"應發數量"為負值。
# Modify.........: No.FUN-A30093 10/04/15 By jan bmb14='3'時，產生工單備料時,sfa11為'C'
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-A60197 10/06/30 By liuxqa sfa012,sfa013 賦初值。
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50022 11/05/06 By Mandy---GP5.25 追版----------------------end---
# Modify.........: No.FUN-B50101 11/05/20 By Mandy GP5.25 平行製程 影響APS程式調整
# Modify.........: No:FUN-B50180 11/06/15 By Abby  部門/廠商欄位開窗時只有顯示部門資料,應同asfi301考慮工單型態後在決定顯示部門還是廠商
# Modify.........: No:FUN-B60149 11/06/30 By Abby  abmi600如果有相同料號時改抓取最近生效日期的料號，其最近生效日相同則取項次最大
# Modify.........: No:TQC-B70121 11/07/19 By Abby  更新工單備料的原發數量(sfa04)/應發數量(sfa05)/實際QPA(sfa161)時有誤
# Modify.........: No.CHI-B80096 11/09/02 By xianghui 對組成用量(ecm62)/底數(63)/ecm66(關鍵報工點否)的預設值處理
# Modify.........: No:FUN-B90017 11/09/05 By Abby  1.若APS回傳外包商代號時，且無特別指定，則在asfi301中帶出原外包商代碼
#                                                  2.若APS回傳VENDER(虛擬外包商)，且無特別指定，則在asfi301中帶空白
#                                                  3.不論APS回傳包商代號或虛擬外包商號碼，有特別指定，則在asfi301中帶出指定
# Modify.........: No:CHI-B80053 11/10/06 By johung 成本中心是null時，帶入輸入料號的ima34
# Modify.........: No:FUN-BA0020 11/10/28 By Abby  apsp820 需產生vmn20/vmn21,規則:單一標準工時vmn20=ecb19,單一標準機時vmn21=ecb21
# Modify.........: No:FUN-BA0032 11/10/28 By Abby  當工單型態撰擇:7:委外工單時,單身多show 委外廠商欄位,但是當工單型態為:1:一般工單時,不show出此欄位
# Modify.........: No.FUN-BB0085 11/12/08 By xianghui 增加數量欄位小數取位
# Modify.........: No:FUN-D10086 13/01/18 By Mandy apsp810 產生工單 For GP5.3 版本差異欄位調整

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_sfb	      RECORD LIKE sfb_file.* #FUN-840008
DEFINE g_ima          RECORD LIKE ima_file.* #FUN-880010
DEFINE g_wc,g_sql     STRING
DEFINE g_t1           LIKE sfb_file.sfb01
DEFINE i,j,k	      LIKE type_file.num10  
DEFINE g_apsdb        LIKE type_file.chr21 
DEFINE g_chr          LIKE type_file.chr1 
DEFINE g_cnt          LIKE type_file.num10      
DEFINE g_i            LIKE type_file.num5          #count/index for any purpose  
DEFINE g_msg          LIKE type_file.chr1000 
DEFINE g_sfb01        LIKE sfb_file.sfb01    
DEFINE g_ima67        LIKE ima_file.ima67  #FUN-880010 add
DEFINE g_vod39        LIKE vod_file.vod39  #FUN-880010 add 
DEFINE l_za05         LIKE type_file.chr1000 
DEFINE g_change_lang  LIKE type_file.chr1   
DEFINE g_opseq        LIKE sfa_file.sfa08
DEFINE g_offset       LIKE sfa_file.sfa09
#------mandy add---
DEFINE g_vlz           RECORD LIKE vlz_file.*
DEFINE g_vod01          LIKE vod_file.vod01     
DEFINE g_vod02          LIKE vod_file.vod02
DEFINE g_rec_b          LIKE type_file.num5       #單身筆數    
DEFINE l_ac             LIKE type_file.num5       #目前處理的ARRAY CNT
DEFINE g_forupd_sql     STRING                    #SELECT ... FOR UPDATE NOWAIT NOWAIT SQL
DEFINE g_select         LIKE type_file.num5
DEFINE g_vod           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         select         LIKE type_file.chr1,      
         planner        LIKE ima_file.ima67,  #FUN-880010 add         
         vod09          LIKE vod_file.vod09,
         ima02          LIKE ima_file.ima02,
         ima021         LIKE ima_file.ima021,
         ima08          LIKE ima_file.ima08,  #FUN-880024 add
         vod16          LIKE vod_file.vod16,#FUN-870013 add
         vod28          LIKE vod_file.vod28,#FUN-870013 add
         vod29          LIKE vod_file.vod29,#FUN-870013 add
         vod10          LIKE vod_file.vod10,
         vod11          LIKE vod_file.vod11,
         vod04          LIKE vod_file.vod04,#FUN-9B0091 add
         vod35          LIKE vod_file.vod35,
         vod35_pro      LIKe vod_file.vod35,#FUN-870013 add
         vod03          LIKE vod_file.vod03,
         route          LIKE vod_file.vod39, #FUN-880010 add
         vod20          LIKE vod_file.vod20,  #FUN-930118 ADD
         vod41          LIKE vod_file.vod41,  #FUN-930118 ADD
         voo04          LIKE voo_file.voo04   #FUN-BA0032 add
                       END RECORD
DEFINE g_vod_t         RECORD                  #程式變數 (舊值)
         select         LIKE type_file.chr1,              
         planner        LIKE ima_file.ima67,  #FUN-880010 add 
         vod09          LIKE vod_file.vod09,
         ima02          LIKE ima_file.ima02,
         ima021         LIKE ima_file.ima021,
         ima08          LIKE ima_file.ima08,  #FUN-880024 add
         vod16          LIKE vod_file.vod16,#FUN-870013 add
         vod28          LIKE vod_file.vod28,#FUN-870013 add
         vod29          LIKE vod_file.vod29,#FUN-870013 add
         vod10          LIKE vod_file.vod10,
         vod11          LIKE vod_file.vod11,
         vod04          LIKE vod_file.vod04,#FUN-9B0091 add
         vod35          LIKE vod_file.vod35,
         vod35_pro      LIKe vod_file.vod35,#FUN-870013 add
         vod03          LIKE vod_file.vod03,
         route          LIKE vod_file.vod39, #FUN-880010 add
         vod20          LIKE vod_file.vod20,  #FUN-930118 ADD
         vod41          LIKE vod_file.vod41,  #FUN-930118 ADD
         voo04          LIKE voo_file.voo04   #FUN-BA0032 add
                    END RECORD

MAIN
#FUN-B50022---mod---str----
   DEFINE l_sql        STRING,       #NO.FUN-910082  
          l_chr       LIKE type_file.chr1     
   DEFINE l_flag      LIKE type_file.chr1           
   DEFINE ls_date     STRING          

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
#FUN-B50022---mod---end----				 

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET ls_date  = ARG_VAL(2)
   LET g_sfb.sfb02 = ARG_VAL(3)
   LET g_sfb.sfb81 = cl_batch_bg_date_convert(ls_date)
   LET g_sfb.sfb01 = ARG_VAL(4)
   LET g_sfb.sfb82 = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(5)              #背景作業
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

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-B50022 mod

   WHILE TRUE 
      CLEAR FORM  
      CALL p820_cre_tmp()              # 建立本程式所有會用到的TEMP TABLE #TQC-860035 add
      IF g_bgjob = "N" THEN
         CALL p820_ask()
         CALL p820_get_vlz()  #抓參數
         LET g_rec_b = 0
         CALL p820_b_fill()            #單身填充
         IF g_rec_b = 0 THEN
             CALL cl_err('','apm-204',1) #單身無符合條件之資料
             CONTINUE WHILE
         END IF
         CALL p820_b()
         LET g_select = 0
         CALL p820_ins_vod_tmp() #TQC-860035 mod
         IF g_select = 0 THEN
              #沒有符合條件的資料,請重新選擇
              CALL cl_err('','aic-044',1)
              CONTINUE WHILE
         END IF
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p820()
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
               CLOSE WINDOW p820
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p820()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #FUN-B50022 mod
END MAIN

FUNCTION p820_ask()
   DEFINE li_result    LIKE type_file.num5        
   DEFINE lc_cmd       LIKE type_file.chr1000     
  #DEFINE p_row,p_col  LIKE type_file.num5  #FUN-B50022 mark      

#FUN-B50022---mod---str---
   OPEN WINDOW p820_w WITH FORM "aps/42f/apsp820" 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
#FUN-B50022---mod---end---    
   CALL cl_ui_init()

  #CALL cl_set_comp_visible("vod03",FALSE) #TQC-860035 mark
   CALL cl_set_comp_visible("vod36",FALSE) #FUN-870013 add
   CALL cl_set_comp_visible("vod28,vod29,vod35",FALSE) #FUN-9A0028 add 將單身欄位vod28,vod29,vod35 隱藏

   #FUN-930118  ADD --STR--
   #TQC-990134---mod---str----
   #SELECT vzy01,vzy02 INTO g_vod01,g_vod02
   #  FROM vzy_file,
   #      (SELECT max(vzy12) mvzy12 FROM vzy_file
   #        WHERE vzy10 is NULL
   #          AND vzy00 = g_plant
   #          AND vzy12 is not NULL)
   #  WHERE vzy10 is NULL  and vzy00=g_plant  and vzy12=mvzy12
    SELECT vzy01,vzy02 INTO g_vod01,g_vod02
      FROM vzy_file
      WHERE vzy10 IS NULL  
        AND vzy00 = g_plant  
        AND vzy12 = (SELECT MAX(vzy12) FROM vzy_file
                      WHERE vzy10 IS NULL
                        AND vzy00 = g_plant
                        AND vzy12 IS NOT NULL)
   #TQC-990134---mod---end----
    DISPLAY BY NAME g_vod01,g_vod02
  #FUN-930118  ADD  --END--

   INITIALIZE g_sfb.* TO NULL
   LET g_sfb.sfb02 = '1'
   LET g_sfb.sfb81 = g_today
   LET g_sfb.sfb44 = g_user   #FUN-9A0031 add
   SELECT MIN(smyslip) 
     INTO g_sfb.sfb01 
     FROM smy_file
    WHERE smysys = 'asf' 
      AND smykind= '1'
   SELECT gen03 INTO g_sfb.sfb82 
     FROM gen_file 
    WHERE gen01=g_user
   LET g_t1 = g_sfb.sfb01 #TQC-860035 add

 WHILE TRUE  
   #FUN-880010  add ima67,vod39
   #CONSTRUCT BY NAME g_wc ON vod11, vod36,vod09,ima67,vod39  #FUN-930118 MARK
    CONSTRUCT BY NAME g_wc ON vod11, vod36,vod09,ima67,vod39,vod20,vod41  #FUN-930118 ADD
      BEFORE CONSTRUCT
         CALL cl_qbe_init()

      #FUN-930118  MARK  --STR--
      ##FUN-880010  add
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
   
      ON ACTION qbe_select
         CALL cl_qbe_select()

      ON ACTION controlp
         CASE
             WHEN INFIELD(vod36)      
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO vod36
                  NEXT FIELD vod36
             WHEN INFIELD(vod09) #item
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_ima18" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO vod09
                  NEXT FIELD vod09

             #供給法則
             #FUN-930118 ADD   --STR-------------------
             WHEN INFIELD(vod41) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_vmh01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO vod41
                  NEXT FIELD vod41
             #FUN-930118 ADD   --END-------------------

             #FUN-880010  add  ima67
             WHEN INFIELD(ima67) #計劃員
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima67
                  NEXT FIELD ima67

             OTHERWISE EXIT CASE
         END CASE

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030	#FUN-B50022 add
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p820
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	 #FUN-B50022 add
      EXIT PROGRAM
   END IF
   LET g_bgjob = 'N' 
  #FUN-9A0031---mod---str---
  #add sfb44
  #INPUT g_vod01,g_vod02,g_sfb.sfb02,g_sfb.sfb81,g_sfb.sfb01,g_sfb.sfb82 WITHOUT DEFAULTS  
  # FROM vod01  ,  vod02,      sfb02,      sfb81,      sfb01,      sfb82
   INPUT g_vod01,g_vod02,g_sfb.sfb02,g_sfb.sfb44,g_sfb.sfb81,g_sfb.sfb01,g_sfb.sfb82 WITHOUT DEFAULTS  
    FROM vod01  ,  vod02,      sfb02,      sfb44,      sfb81,      sfb01,      sfb82
  #FUN-9A0031---mod---end---
 
     AFTER FIELD sfb81
         IF cl_null(g_sfb.sfb81) THEN
            NEXT FIELD sfb81
         END IF
      AFTER FIELD sfb01
         IF cl_null(g_sfb.sfb01) THEN
            NEXT FIELD sfb01 
         END IF
         LET g_t1=s_get_doc_no(g_sfb.sfb01)

         CALL s_check_no("asf",g_t1,"","1","","","")
              RETURNING li_result,g_sfb.sfb01
         IF (NOT li_result) THEN
              NEXT FIELD sfb01
         END IF
        #CALL s_auto_assign_no("asf",g_sfb.sfb01,g_sfb.sfb81,"1","sfb_file","sfb01",
        #         "","","")
        #    RETURNING li_result,g_sfb.sfb01
        #IF g_bgjob = 'N' THEN
        #   DISPLAY BY NAME g_sfb.sfb01    
        #END IF
     #FUN-880024 mark
     #AFTER FIELD sfb82
     #   IF cl_null(g_sfb.sfb82) THEN
     #      NEXT FIELD sfb82
     #   END IF

     #FUN-B50180 add str--------
      AFTER FIELD sfb82
         IF NOT cl_null(g_sfb.sfb82) THEN
            IF g_sfb.sfb02=7 THEN
               SELECT * FROM pmc_file
                WHERE pmc01=g_sfb.sfb82
                  AND pmcacti= 'Y'
               IF STATUS THEN
                  CALL cl_err3("sel","pmc_file",g_sfb.sfb82,"",STATUS,"","sel pmc",1)
                  NEXT FIELD sfb82
               END IF
            ELSE
               SELECT * FROM gem_file
                WHERE gem01=g_sfb.sfb82
                  AND gemacti='Y'
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_sfb.sfb82,"",STATUS,"","sel gem",1)
                  NEXT FIELD sfb82
               END IF
            END IF
         END IF

      AFTER FIELD sfb02
         IF NOT cl_null(g_sfb.sfb02) THEN
            IF NOT cl_null(g_sfb.sfb82) THEN
               IF g_sfb.sfb02=7 THEN
                  SELECT * FROM pmc_file
                   WHERE pmc01=g_sfb.sfb82
                     AND pmcacti= 'Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","pmc_file",g_sfb.sfb82,"",STATUS,"","sel pmc",1)
                     NEXT FIELD sfb02
                  END IF
               ELSE
                  SELECT * FROM gem_file
                   WHERE gem01=g_sfb.sfb82
                     AND gemacti='Y'
                  IF STATUS THEN
                     CALL cl_err3("sel","gem_file",g_sfb.sfb82,"",STATUS,"","sel gem",1)
                     NEXT FIELD sfb02
                  END IF
               END IF
            END IF
        END IF
     #FUN-B50180 add end--------

      #FUN-9A0031 add----str----
      AFTER FIELD sfb44
          IF NOT cl_null(g_sfb.sfb44) THEN
              SELECT * FROM gen_file 
               WHERE gen01 = g_sfb.sfb44
              IF SQLCA.sqlcode = 100 THEN
                  CALL cl_err(g_sfb.sfb44,'mfg1312',1)
                  NEXT FIELD sfb44
              END IF
          END IF
      #FUN-9A0031 add----end----

      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(vod01)
                  #FUN-930118  MARK  --STR--
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_vod"
                  #LET g_qryparam.default1 = g_vod01
                  #LET g_qryparam.arg1     = g_plant CLIPPED
                  #CALL cl_create_qry() RETURNING g_vod01,g_vod02
                  #DISPLAY BY NAME g_vod01,g_vod02
                  #FUN-930118  MARK  --END--

                  #FUN-930118  ADD  --STR--
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_vzy05"
                   LET g_qryparam.arg1     = g_plant CLIPPED
                   CALL cl_create_qry() RETURNING g_vod01
                   LET  g_vod02 = NULL
                  #TQC-990134---mod----str----
                  #SELECT vzy02 INTO g_vod02
                  #FROM vzy_file,
                  #     (SELECT vzy00 mvzy00,vzy01 mvzy01,max(vzy12) mvzy12
                  #        FROM vzy_file
                  #        WHERE vzy00 = g_plant
                  #          AND vzy01 = g_vod01
                  #          AND vzy12 IS NOT NULL
                  #          AND(vzy10 IS NULL)
                  #        GROUP BY vzy00,vzy01)  mvzy_file
                  #WHERE vzy00 = mvzy00
                  #  AND vzy01 = mvzy01
                  #  AND vzy12 = mvzy12
                  #  AND vzy00 = g_plant
                  #  AND (vzy10 IS NULL)
                   SELECT vzy02 INTO g_vod02
                     FROM vzy_file
                    WHERE vzy00 = g_plant
                      AND vzy01 = g_vod01
                      AND vzy10 IS NULL
                      AND vzy12 = (SELECT MAX(vzy12) mvzy12
                                     FROM vzy_file
                                    WHERE vzy00 = g_plant
                                      AND vzy01 = g_vod01
                                      AND vzy10 IS NULL
                                      AND vzy12 IS NOT NULL)
                  #TQC-990134---mod----end----
                  #FUN-930118  ADD  --END--
                  NEXT FIELD vod01
            WHEN INFIELD(sfb01) #order nubmer
              LET g_t1=s_get_doc_no(g_sfb.sfb01)
              CALL q_smy('FALSE','FALSE',g_t1,'ASF','1') RETURNING g_t1  
              LET g_sfb.sfb01=g_t1
              DISPLAY BY NAME g_sfb.sfb01 
              NEXT FIELD sfb01
            WHEN INFIELD(sfb82) #製造部門
             #FUN-B50180 add str------------------------
              IF  g_sfb.sfb02=7 THEN
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc2"
                  LET g_qryparam.default1 = g_sfb.sfb82
                  CALL cl_create_qry() RETURNING g_sfb.sfb82
              ELSE
             #FUN-B50180 add end-----------------------
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 =g_sfb.sfb82
                  CALL cl_create_qry() RETURNING g_sfb.sfb82
              END IF                                           #FUN-B50180 add
              DISPLAY BY NAME g_sfb.sfb82
              NEXT FIELD sfb82

            #FUN-9A0031---add----str----
            #add 申請人
            WHEN INFIELD(sfb44)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 =g_sfb.sfb44  
                 CALL cl_create_qry() RETURNING g_sfb.sfb44
                 DISPLAY BY NAME g_sfb.sfb44
                 NEXT FIELD sfb44
            #FUN-9A0031---add----end----
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
 
      ON ACTION locale
         LET g_change_lang = TRUE       
         EXIT INPUT 
   
      ON ACTION qbe_save
         CALL cl_qbe_save()

   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p820
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	  #FUN-B50022 add
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apsp820"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apsp820','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",g_sfb.sfb02 CLIPPED,"'",
                      " '",g_sfb.sfb81 CLIPPED,"'",
                      " '",g_sfb.sfb01 CLIPPED,"'",
                      " '",g_sfb.sfb82 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apsp820',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p820
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	   #FUN-B50022 add
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION


FUNCTION p820()
  DEFINE l_name	   LIKE type_file.chr20   
  DEFINE l_vod	   RECORD LIKE vod_file.*
  DEFINE l_cnt     LIKE type_file.num5       #FUN-880024 add
  DEFINE l_show_errmsg LIKE type_file.chr1   #FUN-880024 add
  DEFINE l_prt_rep     LIKE type_file.chr1   #FUN-880024 add
  DEFINE l_ze03        LIKE ze_file.ze03     #FUN-880024 add
  DEFINE l_ima08       LIKE ima_file.ima08   #FUN-880024 add
  DEFINE l_imaacti     LIKE ima_file.imaacti #FUN-880024 add
  DEFINE l_vod10       LIKE type_file.chr100 #FUN-9A0029 add
  DEFINE l_vod11       LIKE type_file.chr100 #FUN-9A0029 add

  SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

  #TQC-860035---mod---str---
 #LET g_sql="SELECT vod_file.* ",              #FUN-9A0029 mark
  LET g_sql="SELECT vod_file.*,vod_file.vod10 vd10,vod_file.vod11 vd11",  #FUN-9A0029 add
            "  FROM vod_file , vod_tmp ",
            " WHERE vod_file.vod00 = vod_tmp.vod00 ",
            "   AND vod_file.vod01 = vod_tmp.vod01 ",
            "   AND vod_file.vod02 = vod_tmp.vod02 ",
            "   AND vod_file.vod03 = vod_tmp.vod03 ",
           #挪到FOREACH p820_c內做判斷 
           #"   AND vod_file.vod35 > 0 ",            #建議數量 
           #"   AND vod_file.vod03 LIKE 'APS_MO%' ", #製令編號
           #"   AND vod_file.vod09 IN ( SELECT DISTINCT bma01 ", 
           #"                  FROM bma_file,ima_file ",
           #"                 WHERE bma05 IS NOT NULL ", 
           #"                   AND bma05   <= '",g_sfb.sfb81,"'",  #BOM發放日
           #"                   AND bma06   = ima910 ",         
           #"                   AND bmaacti = 'Y' ",  
           #"                   AND bma01 = ima01 ", #FUN-880024 add
           #"                   AND ima08 <> 'X' ",  #FUN-880024 add
           #"                   AND ima08 <> 'P') ",
           #"   AND ",g_wc CLIPPED , #FUN-9C0144 mark
            " ORDER BY vod09,vod11,vod_file.vod03 "
  #TQC-860035---mod---end---

   PREPARE p820_p FROM g_sql
   DECLARE p820_c CURSOR FOR p820_p
   CALL cl_outnam('apsp820') RETURNING l_name
   CALL cl_prt_pos_len()  #TQC-860035 add
   START REPORT p820_rep TO l_name
   #FUN-880024---str---
   #FOREACH 內加show錯誤訊息資訊
   CALL s_showmsg_init()   
   LET l_show_errmsg = 'N'
   LET l_prt_rep = 'N'
   FOREACH p820_c INTO l_vod.*,l_vod10,l_vod11  #FUN-9A0029 add l_vod10,l_vod11
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:p820_c',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	#FUN-B50022 add
         EXIT PROGRAM
      END IF
      LET l_prt_rep = 'Y'
      IF l_vod.vod35 <= 0 THEN
          LET g_showmsg = 'vod35 <= 0 '
          CALL s_errmsg('vod35',g_showmsg,l_vod.vod03,STATUS,1)
          LET l_show_errmsg = 'Y'
          LET l_prt_rep = 'N'
          CONTINUE FOREACH
      END IF
     #FUN-9A0089---mark---str---
     #IF l_vod.vod03 NOT MATCHES 'APS_MO*' THEN
     #    LET g_showmsg = "WO:",l_vod.vod03 CLIPPED," <>'APS_MO*'"
     #    CALL s_errmsg('vod03',g_showmsg,l_vod.vod03,STATUS,1)
     #    LET l_show_errmsg = 'Y'
     #    LET l_prt_rep = 'N'
     #    CONTINUE FOREACH
     #END IF
     #FUN-9A0089---mark---end---
      SELECT ima08,imaacti INTO l_ima08,l_imaacti
        FROM ima_file
       WHERE ima01 = l_vod.vod09
      IF l_imaacti <> 'Y' THEN
          CALL cl_getmsg('aco-172',g_lang) RETURNING g_showmsg #該編號為無效資料!
          LET g_showmsg = l_vod.vod09,'==>',g_showmsg
          CALL s_errmsg('vod09',g_showmsg,l_vod.vod03,STATUS,1)
          LET l_show_errmsg = 'Y'
          LET l_prt_rep = 'N'
          CONTINUE FOREACH
      END IF
      IF l_ima08 MATCHES '[XP]' THEN
          CALL cl_getmsg('amm1002',g_lang) RETURNING g_showmsg #注意 !!! 此料件為虛擬料件或為採購料件
          LET g_showmsg = l_vod.vod09,'==>',g_showmsg
          CALL s_errmsg('vod09',g_showmsg,l_vod.vod03,STATUS,1)
          LET l_show_errmsg = 'Y'
          LET l_prt_rep = 'N'
          CONTINUE FOREACH
      END IF
     #FUN-880024--mark--str-
     #不判斷BOM結構,因為已抓APS建議voe_file
     #SELECT COUNT(*) INTO l_cnt
     #  FROM bma_file,ima_file 
     # WHERE bma05 IS NOT NULL  
     #   AND bma05 <= g_sfb.sfb81 #BOM發放日
     #   AND bma06  = ima910         
     #   AND bmaacti = 'Y' 
     #   AND bma01 = ima01 
     #   AND bma01 = l_vod.vod09
     #IF l_cnt <= 0 THEN
     #    CALL cl_getmsg('abm-742',g_lang) RETURNING l_ze03 #無此產品結構資料!
     #    LET g_showmsg = l_vod.vod09 ,'==>',l_ze03
     #    CALL cl_getmsg('asf-014',g_lang) RETURNING l_ze03 #此料件之產品結構無效,請查核..!
     #    LET g_showmsg = g_showmsg,' OR ',l_ze03
     #    CALL s_errmsg('vod09',g_showmsg,l_vod.vod03,STATUS,1)
     #    LET l_show_errmsg = 'Y'
     #    LET l_prt_rep = 'N'
     #    CONTINUE FOREACH
     #END IF
     #FUN-880024--mark--end-
      IF l_prt_rep = 'Y' THEN
          OUTPUT TO REPORT p820_rep(l_vod.*,l_vod10,l_vod11) #FUN-9A0029 add l_vod10,l_vod11
      END IF
   END FOREACH
   IF l_show_errmsg = 'Y' THEN
       CALL s_showmsg()   
   END IF
   FINISH REPORT p820_rep
   IF l_prt_rep = 'Y' THEN
       CALL cl_prt(l_name,' ','1',g_len)
       IF NOT cl_confirm('amr-078') THEN
          LET g_success='N'
       END IF
   ELSE
       LET g_success = 'N'
   END IF
   #FUN-880024---end---
END FUNCTION

REPORT p820_rep(l_vod,l_vod10,l_vod11) #FUN-9A0029 add l_vod10,l_vod11
  DEFINE l_ecu012       LIKE ecu_file.ecu012  #FUN-B50022 add
  DEFINE l_string       STRING                #TQC-8A0014 add
  DEFINE l_str_sfb221   STRING                #TQC-8A0014 add
  DEFINE l_digits0      LIKE type_file.num5   #TQC-8A0014 add
  DEFINE l_digits1      LIKE type_file.num5   #TQC-8A0014 add
  DEFINE l_digits2      LIKE type_file.num5   #TQC-8A0014 add
  DEFINE l_i            LIKE type_file.num5   #TQC-8A0014 add
  DEFINE l_vod	        RECORD LIKE vod_file.*
  DEFINE l_vod10       LIKE type_file.chr100 #FUN-9A0029 add
  DEFINE l_vod11       LIKE type_file.chr100 #FUN-9A0029 add
  DEFINE li_result      LIKE type_file.num5    
  DEFINE l_factor       LIKE vod_file.vod29   #FUN-870013 add
  DEFINE l_cnt          LIKE type_file.num5   #FUN-870013 add
  DEFINE l_ima08        LIKE ima_file.ima08,
         l_smy57        LIKE smy_file.smy57,  
         l_smyapr       LIKE smy_file.smyapr, #FUN-9C0011 add
         l_chr          LIKE ahe_file.ahe01, 
         l_ima02        LIKE ima_file.ima02,
         l_ima25        LIKE ima_file.ima25,     
         l_ima55        LIKE ima_file.ima55,    
         l_ima55_fac    LIKE ima_file.ima55_fac,
         l_last_sw      LIKE type_file.chr1     
 #DEFINE l_sfbi         RECORD LIKE sfbi_file.*   #TQC-990134 mark
  DEFINE l_voo05        LIKE voo_file.voo05    #FUN-960107 ADD
  DEFINE l_ecm012       LIKE ecm_file.ecm012   #CHI-B80096 add

  OUTPUT TOP MARGIN g_top_margin 
         LEFT MARGIN g_left_margin 
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line   

  ORDER EXTERNAL BY l_vod.vod09,l_vod.vod11 #TQC-860035 mod
  FORMAT
    PAGE HEADER
      LET l_last_sw = 'n'
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len] CLIPPED
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED
      PRINT g_dash1

    ON EVERY ROW
      IF cl_null(g_sfb.sfb01[g_no_sp,g_no_ep]) THEN 
         CALL s_auto_assign_no("asf",g_sfb.sfb01,g_sfb.sfb81,"1","sfb_file","sfb01","","","")  
              RETURNING li_result,g_sfb.sfb01
         IF (NOT li_result) THEN                                                                                                       
             LET g_success='N'
             IF g_bgjob = 'Y' THEN 
                 CALL cl_batch_bg_javamail("N") 
             END IF 
             CALL cl_err('','asf-377',1) #自動編號錯誤, 無法繼續執行!! #TQC-860035 add
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211  #FUN-B50022 add
             EXIT PROGRAM 
         END IF 
      END IF
      LET g_sfb01 = g_sfb.sfb01        
      SELECT ima08,ima25,ima55,ima55_fac 
        INTO l_ima08,l_ima25,l_ima55,l_ima55_fac
        FROM ima_file 
       WHERE ima01=l_vod.vod09   
      IF STATUS THEN 
          LET l_ima08='M' 
      END IF
     #FUN-880024---mark
     #是否為委外工單目前是抓料件基本檔,應抓APS資料,join voo_file,有值的,表示為委外工單
     #IF l_ima08='M' OR l_ima08='T' THEN 
     #    LET g_sfb.sfb02='1' #工單型態==>1:一般工單
     #END IF
     #IF l_ima08='S' THEN 
     #    LET g_sfb.sfb02='7' #工單型態==>7:委外工單
     #END IF
      LET g_sfb.sfb04  ='1'
      LET g_sfb.sfb05  = l_vod.vod09
      SELECT smy57,smyapr INTO l_smy57,l_smyapr #FUN-9C0011 add smyapr
        FROM smy_file 
       WHERE smyslip=g_t1          
     #IF l_smy57[1,1]='Y' THEN #工單製程否       #FUN-880010 mark
         LET g_sfb.sfb06 = l_vod.vod14 CLIPPED
     #END IF                                     #FUN-880010 mark
      LET g_sfb.sfb071 = l_vod.vod11 #有效日期  
     #FUN-9A0028--mark---str---
     ##FUN-870013---add----str---
     #IF l_vod.vod28 <> l_vod.vod16 THEN              
     #    LET l_factor = 1
     #    #庫存/生產單位換算率
     #    CALL s_umfchk(l_vod.vod09,l_vod.vod28,l_vod.vod16) 
     #         RETURNING l_cnt,l_factor
     #    IF l_cnt = 1 THEN
     #       LET l_factor = 1
     #    END IF
     #    LET g_sfb.sfb08 = l_vod.vod35 * l_factor
     #ELSE                                             
     #    LET g_sfb.sfb08 = l_vod.vod35
     #END IF
     ##FUN-870013---add----end---
     #FUN-9A0028--mark---end---
     #FUN-9A0028--add----str---
      #vod35的量,已是用生產數量來看,不需要再*單位換算率
      LET g_sfb.sfb08 = l_vod.vod35
     #FUN-9A0028--add----end---
      LET g_sfb.sfb081 = 0
      LET g_sfb.sfb09  = 0
      LET g_sfb.sfb10  = 0
      LET g_sfb.sfb11  = 0
      LET g_sfb.sfb111 = 0  
      LET g_sfb.sfb12  = 0
      LET g_sfb.sfb121 = 0 #FUN-D10086 add #在製盤盈虧量
     #FUN-9A0029 mod---str----
     #LET g_sfb.sfb13  = l_vod.vod11   #預計開工日
     #LET g_sfb.sfb15  = l_vod.vod10   #預計完工日
      LET g_sfb.sfb13  = l_vod11[1,10] #預計開工日
      LET g_sfb.sfb14  = l_vod11[12,19] 
      LET g_sfb.sfb15  = l_vod10[1,10]   #預計完工日
      LET g_sfb.sfb16  = l_vod10[12,19] 
     #FUN-9A0029 mod---end----
      LET g_sfb.sfb222 = l_vod.vod03   #APS 單據編號
      LET l_cnt = 0 
      #FUN-960107-----add-----str---
      #備料檔產生否(sfb23),應該判斷是否有備料檔,決定此欄位值
      SELECT COUNT(*) INTO l_cnt
        FROM voe_file
       WHERE voe00 = g_plant
         AND voe01 = g_vod01
         AND voe02 = g_vod02
         AND voe03 = l_vod.vod03
      IF l_cnt >= 1 THEN
          LET g_sfb.sfb23  = 'Y'
      ELSE
          LET g_sfb.sfb23  = 'N'
      END IF
      #FUN-960107-----add-----end---
     #LET g_sfb.sfb23  ='N' #FUN-960107 mark
      LET g_sfb.sfb24  ='N'
      LET g_sfb.sfb251 = g_sfb.sfb13   #FUN-D10086 add #預計發放日期
      LET g_sfb.sfb29  ='Y'
      LET g_sfb.sfb32  = 0
      LET g_sfb.sfb34  = 1
      LET g_sfb.sfb35  ='N'
      LET g_sfb.sfb39  ='1'
      LET g_sfb.sfb41  ='N'
      LET g_sfb.sfb42  = 0
     #FUN-880024---add--str--
      IF g_sfb.sfb02 = '7' THEN #委外工單
         IF cl_null(g_sfb.sfb82) THEN  #FUN-B90017 add
            SELECT voo04 INTO g_sfb.sfb82
              FROM voo_file
             WHERE voo00 = g_plant
               AND voo01 = g_vod01
               AND voo02 = g_vod02
               AND voo03 = l_vod.vod03
           #IF g_sfb.sfb82 = 'VENDER' THEN                              #FUN-B90017 mark
            IF NOT cl_null(g_sfb.sfb82) AND g_sfb.sfb82 = 'VENDER' THEN #FUN-B90017 add
               LET g_sfb.sfb82 = ''
            END IF
         END IF  #FUN-B90017 add
      END IF
     #FUN-880024---add--end--
      LET g_sfb.sfb87  ='N'
      LET g_sfb.sfb87  ='N'
     #IF NOT cl_null(g_sfb.sfb06) THEN                      #FUN-880010 mark
      IF NOT cl_null(l_vod.vod39) AND l_vod.vod39 = 1 THEN  #FUN-880010 mod
          LET g_sfb.sfb93 = 'Y' #製程否
          LET g_sfb.sfb06 = l_vod.vod14 CLIPPED
      ELSE
          LET g_sfb.sfb93 = 'N' #製程否
          LET g_sfb.sfb06 = ' ' #製程編號                   #FUN-870017 add
      END IF
      LET g_sfb.sfb94  = l_smy57[2,2]        #FQC否 
      #TQC-8A0014---mod---str---
     #LET g_sfb.sfb22  = l_vod.vod20         #來源訂單  #TQC-870030-(2)拋轉後產生之工單資料asfi301中訂單編號欄位為空
      LET l_string = l_vod.vod20
      CASE g_aza.aza41 #單別位數
           WHEN '1' #單別位數,3碼
                LET l_digits1 = 3
           WHEN '2' #單別位數,4碼
                LET l_digits1 = 4
           WHEN '3' #單別位數,5碼
                LET l_digits1 = 5
          OTHERWISE
                LET l_digits1 = 3
      END CASE
      CASE g_aza.aza42 #單號位數
           WHEN '1' 
                LET l_digits2 = 8
           WHEN '2' 
                LET l_digits2 = 9
           WHEN '3' 
                LET l_digits2 = 10
          OTHERWISE
                LET l_digits2 = 8
      END CASE
      LET l_digits0 = l_digits1 + 1 + l_digits2
      LET g_sfb.sfb22 = l_string.substring(1,l_digits0)
      FOR l_i = l_digits0+2 TO l_string.getlength()
          IF l_string.substring(l_i,l_i) <> '0' THEN
              LET l_str_sfb221= l_string.substring(l_i,l_string.getlength())
              EXIT FOR #FUN-960107 add,產生工單時,訂單項次(sfb221)為兩位數時,此欄位值不正確
          END IF
      END FOR
      LET g_sfb.sfb221 = l_str_sfb221
      #TQC-8A0014---mod---end---
      #FUN-990088---add---str---
      LET g_sfb.sfb96 = g_sfb.sfb22 CLIPPED,'-',g_sfb.sfb221 USING '<<<<<'
      LET g_sfb.sfb22 = NULL
      LET g_sfb.sfb221= NULL
      #FUN-990088---add---end---
      LET g_sfb.sfb86  = l_vod.vod21         #母工單    #TQC-870030 
      SELECT ima910 INTO g_sfb.sfb95
        FROM ima_file
       WHERE ima01 = g_sfb.sfb05
      IF cl_null(g_sfb.sfb95) THEN
         LET g_sfb.sfb95 = ' '
      END IF
      LET g_sfb.sfb98   = ' ' 
      LET g_sfb.sfbacti = 'Y'
      LET g_sfb.sfbuser = g_user
      LET g_sfb.sfbgrup = g_grup
      LET g_sfb.sfb1002='N' #保稅核銷否 
  #FUN-B50022---add----str---
      LET g_sfb.sfbplant = g_plant #FUN-980006
      LET g_sfb.sfblegal = g_legal #FUN-980006
  #FUN-B50022---add----end---
      SELECT ima02 INTO l_ima02 
        FROM ima_file 
       WHERE ima01=g_sfb.sfb05
      PRINT COLUMN g_c[31],g_sfb01,                   
            COLUMN g_c[32],g_sfb.sfb05[1,15],
            COLUMN g_c[33],l_ima02,
            COLUMN g_c[34],cl_numfor(g_sfb.sfb08,34,g_azi03), 
            COLUMN g_c[35],g_sfb.sfb13,
            COLUMN g_c[36],g_sfb.sfb15,
            COLUMN g_c[37],g_sfb.sfb222   

      #FUN-960107 ADD --STR----------------------------------
       LET l_voo05 = NULL
       SELECT voo05 INTO l_voo05 FROM voo_file
        WHERE voo00 = g_plant
          AND voo01 = g_vod01
          AND voo02 = g_vod02
          AND voo03 = l_vod.vod03
       IF g_sfb.sfb02 = 7 AND l_voo05 = 2 THEN
          LET g_sfb.sfb41 = 'Y'
       END IF
       LET g_sfb.sfb99 = 'N' #重工否(sfb99)欄位預設為N
      #FUN-960107 ADD --END----------------------------------
      #FUN-9C0011---add----str---
      LET g_sfb.sfb100 = l_smy57[6,6] #委外型態==>委外工單對委外採購型態為 1: 一對一 2: 一對多
      IF cl_null(g_sfb.sfb100) THEN
          LET g_sfb.sfb100 = '1'
      END IF
      LET g_sfb.sfbmksg = l_smyapr
      IF cl_null(g_sfb.sfbmksg) THEN
          LET g_sfb.sfbmksg = 'N'
      END IF
      #FUN-9C0011---add----end---
      LET g_sfb.sfb43 = '0' #0:開立                #TQC-B30159 add
      LET g_sfb.sfb98 = s_costcenter(g_sfb.sfb82)  #TQC-B30159 add
#CHI-B80053 -- begin --
      IF cl_null(g_sfb.sfb98) THEN
         SELECT ima34 INTO g_sfb.sfb98 FROM ima_file
          WHERE ima01 = g_sfb.sfb05
      END IF
#CHI-B80053 -- end --
      LET g_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04 #FUN-B50022 add
      LET g_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04 #FUN-B50022 add
      LET g_sfb.sfb104 = 'N'       #No.TQC-A50087 add         #FUN-B50022 add
      INSERT INTO sfb_file VALUES(g_sfb.*)
      IF STATUS THEN
         CALL cl_err3("ins","sfb_file",g_sfb.sfb01,"",STATUS,"","ins sfb:",1)  
         IF g_bgjob = 'Y' THEN 
             CALL cl_batch_bg_javamail("N") 
         END IF  
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	#FUN-B50022 add
         EXIT PROGRAM 
      #FUN-960107 ADD --STR----------------------------------
      ELSE
         IF NOT cl_null(l_voo05) THEN
            INSERT INTO vnf_file(vnf01,vnf03,vnf07,vnflegal,vnfplant) #FUN-B50022 add legal,plant
              VALUES(g_sfb.sfb01,l_voo05,'1',g_legal,g_plant )        #FUN-B50022 add legal,plant
            IF STATUS THEN
               CALL cl_err3("ins","vnf_file",g_sfb.sfb01,"",STATUS,"","ins vnf:",1)
               IF g_bgjob = 'Y' THEN
                  CALL cl_batch_bg_javamail("N")
               END IF
               CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 #FUN-B50022 add
               EXIT PROGRAM
            END IF
         END IF
      #FUN-960107 ADD --END----------------------------------
      END IF
     #TQC-990134---mark---str----
     ##行業別--add --begin
     #IF NOT s_industry('std') THEN
     #   INITIALIZE l_sfbi.* TO NULL
     #   LET l_sfbi.sfbi01 = g_sfb.sfb01
     #   IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
     #      IF g_bgjob = 'Y' THEN 
     #         CALL cl_batch_bg_javamail("N") 
     #      END IF  
     #      EXIT PROGRAM
     #   END IF
     #END IF
     ##行業別add --end
     #TQC-990134---mark---end----

      CALL p820_ins_sfa(l_vod.vod03,g_sfb.sfb02,g_sfb.sfb39) 
      #==>使用製程追蹤
      IF g_sma.sma26='2' THEN
        #IF NOT cl_null(g_sfb.sfb06) THEN #FUN-880010 mark
         IF g_sfb.sfb93 = 'Y' THEN        #FUN-880010 mod
             CALL p820_ins_ecm(l_vod.vod03,l_vod.vod14,g_sfb.sfb08) #FUN-880024 add sfb08
             #FUN-B50022--add----str---
             IF g_sma.sma541='Y' AND g_sfb.sfb93='Y' THEN
                #CHI-B80096-mark-str--
                #SELECT ecu012 INTO l_ecu012 FROM ecu_file
                # WHERE ecu01=g_sfb.sfb05
                #   AND ecu02=g_sfb.sfb06  
                #   AND (ecu015 IS NULL OR ecu015=' ')
                #CALL s_schdat_output(l_ecu012,g_sfb.sfb08,g_sfb.sfb01) 
                #CHI-B80096-mark-end--
                #CHI-B80096-add-str--
                DECLARE ecm012_cs CURSOR FOR 
                 SELECT DISTINCT ecm012
                   FROM ecm_file
                  WHERE ecm01 = g_sfb.sfb01
                    AND (ecm015 IS NULL OR ecm015 = ' ')
                FOREACH ecm012_cs INTO l_ecm012 
                   EXIT FOREACH
                END FOREACH
                CALL s_schdat_output(l_ecm012,g_sfb.sfb08,g_sfb.sfb01)
                #CHI-B80096-add-end--
             ELSE
                CALL s_schdat_output(' ',g_sfb.sfb08,g_sfb.sfb01)  
             END IF
             #FUN-B50022--add----end---
             CALL p820_routing_chk()
             CALL p820_upd_sfa08(l_vod.vod03)   #MOD-940129  add vod03 拋轉
         END IF
      END IF
      CALL p820_upd_vod(l_vod.*,g_sfb.sfb01) #FUN-870013 add
      LET g_sfb.sfb01 = g_t1     

   ON LAST ROW
      LET l_last_sw = 'y'
      PRINT g_dash CLIPPED
      PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7]

   PAGE TRAILER
      IF l_last_sw = 'n'
         THEN PRINT g_dash CLIPPED
         PRINT g_x[4] CLIPPED,g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6]
         ELSE SKIP 2 LINE
      END IF

END REPORT

FUNCTION p820_routing_chk()
  DEFINE l_ecb RECORD LIKE ecb_file.*
  DEFINE l_ima571  LIKE ima_file.ima571
  DEFINE l_ecu01   LIKE ecu_file.ecu01
  DEFINE l_ecu02   LIKE ecu_file.ecu02

  IF NOT cl_null(g_sfb.sfb06) THEN
      SELECT count(*) INTO g_cnt 
        FROM ecm_file 
       WHERE ecm01 = g_sfb.sfb01
      IF g_cnt > 0 THEN 
          LET g_sfb.sfb24 = 'Y' 
      ELSE 
          LET g_sfb.sfb24 = 'N' 
      END IF
      SELECT count(*) INTO g_cnt 
        FROM sfb_file
       WHERE sfb01=g_sfb.sfb01
         AND (sfb13 IS NOT NULL AND sfb15 IS NOT NULL )
      IF g_cnt > 0 THEN
          UPDATE sfb_file 
             SET sfb24=g_sfb.sfb24 
           WHERE sfb01=g_sfb.sfb01
          SELECT sfb13,sfb15 INTO g_sfb.sfb13,g_sfb.sfb15 
            FROM sfb_file
           WHERE sfb01 = g_sfb.sfb01
      ELSE
          UPDATE sfb_file 
             SET sfb13=g_sfb.sfb13,
                 sfb15=g_sfb.sfb15,
                 sfb24=g_sfb.sfb24
           WHERE sfb01 = g_sfb.sfb01
      END IF
  END IF
END FUNCTION 

FUNCTION p820_upd_sfa08(p_vod03)   #MOD-940129   add  vod03 參數
   DEFINE p_vod03    LIKE  vod_file.vod03    #MOD-940129  add
   DEFINE l_vog      RECORD LIKE vog_file.*
   DEFINE l_ecm      RECORD LIKE ecm_file.*

   LET g_sql="SELECT * ",
             "  FROM vog_file ",
             " WHERE vog00 = '",g_plant,"'",
             "   AND vog01 = '",g_vod01,"'",
             "   AND vog02 = '",g_vod02,"'",
             "   AND vog03 = '",p_vod03,"'"   #MOD-940129  ADD

   PREPARE p820_upd_sfa_p FROM g_sql
   DECLARE p820_upd_sfa_d CURSOR FOR p820_upd_sfa_p
   INITIALIZE l_vog.* TO NULL
   FOREACH p820_upd_sfa_d INTO l_vog.*
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        SELECT * INTO l_ecm.* 
          FROM ecm_file
         WHERE ecm01 = l_vog.vog03
           AND ecm03 = l_vog.vog05
        UPDATE sfa_file
           SET sfa08 = l_vog.vog08
         WHERE sfa01 = l_vog.vog01
           AND sfa03 = l_ecm.ecm03_par
        INITIALIZE l_vog.* TO NULL
   END FOREACH
END FUNCTION 



FUNCTION p820_ins_sfa(l_voe03,l_sfb02,l_sfb39)
   DEFINE l_type       LIKE type_file.chr1       #FUN-B30121 add
   DEFINE l_ima	       RECORD LIKE ima_file.*    #FUN-B30121 add
   DEFINE l_main_sfa26 LIKE sfa_file.sfa26       #FUN-B30121 add
   DEFINE l_bmd07      LIKE bmd_file.bmd07       #FUN-B30121 add
   DEFINE l_sfa25      LIKE sfa_file.sfa25       #FUN-B30121 add
   DEFINE l_sfa161     LIKE sfa_file.sfa161      #FUN-B30121 add
   DEFINE l_bml03      LIKE bml_file.bml03       #FUN-B30121 add
   DEFINE l_bml04      LIKE bml_file.bml04       #FUN-B30121 add
   DEFINE l_ima25    LIKE ima_file.ima25       #FUN-9A0028 add
   DEFINE l_factor   LIKE type_file.num26_10   #FUN-9A0028 add
   DEFINE l_voe03    LIKE voe_file.voe03
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_sfb02    LIKE sfb_file.sfb02
   DEFINE l_sfb39    LIKE sfb_file.sfb39
   DEFINE l_sfa13    LIKE sfa_file.sfa13
   DEFINE l_sfa	     RECORD LIKE sfa_file.*
   DEFINE l_bmb	     RECORD LIKE bmb_file.*
   DEFINE l_voe      RECORD LIKE voe_file.*
   DEFINE l_total    LIKE sfa_file.sfa07
   DEFINE l_total2   LIKE sfa_file.sfa07
  #DEFINE l_sfai     RECORD LIKE sfai_file.*       #TQC-990134 mark
   DEFINE l_flag     LIKE type_file.chr1           
   DEFINE l_sfa11_a  LIKE sfa_file.sfa11  #CHI-980013
   DEFINE l_msg      LIKE type_file.chr1000  #FUN-9A0028 add
   DEFINE l_msg_bmb01 LIKE type_file.chr1000 #FUN-9A0028 add
   DEFINE l_msg_bmb03 LIKE type_file.chr1000 #FUN-9A0028 add
   DEFINE l_cnt      LIKE type_file.num5     #TQC-A90102 add
   DEFINE l_mbmb02   LIKE bmb_file.bmb02     #FUN-B60149 add
         
   LET g_sql="SELECT * ",
             "  FROM voe_file ",
             " WHERE voe00 = '",g_plant,"'",
             "   AND voe01 = '",g_vod01,"'",
             "   AND voe02 = '",g_vod02,"'",
             "   AND voe03 = '",l_voe03,"'",
             "   ORDER BY voe15,voe17 "

   PREPARE p820_ins_sfa_p FROM g_sql
   DECLARE p820_ins_sfa_d CURSOR FOR p820_ins_sfa_p
   INITIALIZE l_sfa.* TO NULL
   LET l_sfa.sfa01 = g_sfb01 #工單編號
   LET l_sfa.sfa02 = l_sfb02 #工單型態
   FOREACH p820_ins_sfa_d INTO l_voe.*
                LET l_sfa.sfa03 = l_voe.voe06   #元件編號
               #FUN-9A0028---mark--str----
               #LET l_sfa.sfa04 = l_voe.voe12   #原發數量,預計領用量
               #LET l_sfa.sfa05 = l_voe.voe12   #應發數量,預計領用量
               #FUN-9A0028---mark--end----
               #FUN-B30121---add---str----
                IF g_sma.sma71 = 'Y' THEN
                    LET l_sfa.sfa04 = l_voe.voe12 + l_voe.voe16
                    LET l_sfa.sfa05 = l_voe.voe12 + l_voe.voe16
                ELSE
                    LET l_sfa.sfa04 = l_voe.voe12 
                    LET l_sfa.sfa05 = l_voe.voe12 
                END IF
               #FUN-B30121---add---end----
                LET l_sfa.sfa06 =0
                LET l_sfa.sfa061=0
                LET l_sfa.sfa062=0
                LET l_sfa.sfa063=0
                LET l_sfa.sfa064=0
                LET l_sfa.sfa065=0
                LET l_sfa.sfa066=0
                LET l_sfa.sfa07 =0
#-------------------------------
              #MOD-B20145---mark---str--
              # #找BOM(abmi600)
              # SELECT * INTO l_bmb.*
              #   FROM bmb_file
              # #WHERE bmb01 = g_sfb.sfb05 #FUN-9A0028 mark
              #  WHERE bmb01 = l_voe.voe09 #FUN-9A0028 add
              #    AND bmb03 = l_sfa.sfa03
              #   #AND bmb14 != '1'   #CHI-950037 #CHI-980031
              #    AND (bmb04 <=g_sfb.sfb071
              #         OR bmb04 IS NULL) 
              #    AND (bmb05 > g_sfb.sfb071
              #         OR bmb05 IS NULL)
              #    AND bmb29 = ' ' #FUN-9A0028 add
              # #FUN-9A0028---add-----str-----
              ##FUN-9B0077--mark---str---
              ##IF STATUS THEN
              ##    #此料件不存在BOM�!
              ##    CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
              ##    CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
              ##    LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED," ",
              ##                l_msg_bmb03 CLIPPED,':',l_sfa.sfa03 CLIPPED
              ##    CALL cl_err(l_msg,'aqc-050',1)
              ##    RETURN
              ##END IF
              ##FUN-9B0077--mark---end---
              ##FUN-9B0077--add----str---
              # IF STATUS THEN 
              #     #找取替代BOM(abmi6042)
              #    #TQC-A90102---mark--str---
              #    #SELECT *
              #    #  FROM bmd_file
              #    # WHERE (bmd08 = l_voe.voe09 OR bmd08 = 'ALL' )#主件編號
              #    #   AND bmd04 = l_voe.voe06 #取代替代料件編號 
              #    #   AND bmd01 = l_voe.voe15 #原始料件編號
              #    #IF STATUS THEN
              #    #TQC-A90102---mark--end---
              #    #TQC-A90102---add---str---
              #     SELECT COUNT(*) INTO l_cnt
              #       FROM bmd_file
              #      WHERE (bmd08 = l_voe.voe09 OR bmd08 = 'ALL' )#主件編號
              #        AND bmd04 = l_voe.voe06 #取代替代料件編號 
              #        AND bmd01 = l_voe.voe15 #原始料件編號
              #        AND (bmd05 <=g_sfb.sfb071 #加上生/失效日
              #             OR bmd05 IS NULL) 
              #        AND (bmd06 > g_sfb.sfb071
              #             OR bmd06 IS NULL)
              #     IF l_cnt = 0 THEN
              #    #TQC-A90102---add---end---
              #         CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
              #         CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
              #         LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED," ",
              #                     l_msg_bmb03 CLIPPED,':',l_sfa.sfa03 CLIPPED
              #         #此料件不存在BOM或取代替BOM�!
              #         CALL cl_err(l_msg,'aps-036',1)
              #         RETURN
              #     ELSE
              #         LET l_sfa.sfa27 = l_voe.voe06
              #         LET l_sfa.sfa26 = '0'
              #         #再用原始料件編號反推abmi600
              #         #找BOM(abmi600)
              #         SELECT * INTO l_bmb.*
              #           FROM bmb_file
              #          WHERE bmb01 = l_voe.voe09 
              #            AND bmb03 = l_voe.voe15
              #            AND (bmb04 <=g_sfb.sfb071
              #                 OR bmb04 IS NULL) 
              #            AND (bmb05 > g_sfb.sfb071
              #                 OR bmb05 IS NULL)
              #            AND bmb29 = ' ' 
              #         IF STATUS THEN
              #             CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
              #             CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
              #             LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED," ",
              #                         l_msg_bmb03 CLIPPED,':',l_voe.voe15 CLIPPED
              #             #此料件不存在BOM或取代替BOM�!
              #             CALL cl_err(l_msg,'aps-036',1)
              #             RETURN
              #         END IF
              #     END IF
              # ELSE
              #     LET l_sfa.sfa27 = l_voe.voe15 
              #     LET l_sfa.sfa26 = l_bmb.bmb16 
              # END IF
              ##FUN-9B0077--add----end---
              #MOD-B20145---mark---end--

             #FUN-B30121---mark---str---
             ##MOD-B20145---add----str--
             #  #找BOM(abmi600)
             #  SELECT COUNT(*) INTO l_cnt
             #    FROM bmb_file
             #   WHERE bmb01 = l_voe.voe09 
             #     AND bmb03 = l_sfa.sfa03
             #     AND (bmb04 <=g_sfb.sfb071
             #          OR bmb04 IS NULL) 
             #     AND (bmb05 > g_sfb.sfb071
             #          OR bmb05 IS NULL)
             #     AND bmb29 = ' ' 
             #  IF l_cnt >=1 AND (l_voe.voe06 = l_voe.voe15) THEN
             #      #=>不為替代料情況
             #      #voe06(發料料號)在ERP的BOM找的到
             #      #且voe06(發料料號) = voe15(被替代料號)

             #      #找BOM(abmi600)
             #      SELECT * INTO l_bmb.*
             #        FROM bmb_file
             #       WHERE bmb01 = l_voe.voe09 
             #         AND bmb03 = l_sfa.sfa03
             #         AND (bmb04 <=g_sfb.sfb071
             #              OR bmb04 IS NULL) 
             #         AND (bmb05 > g_sfb.sfb071
             #              OR bmb05 IS NULL)
             #         AND bmb29 = ' ' 
             #      LET l_sfa.sfa27 = l_voe.voe15 
             #      LET l_sfa.sfa26 = l_bmb.bmb16 
             #  ELSE
             #      #=>為替代料情況
             #      #voe06(發料料號)在ERP的BOM找不到 
             #      #或是 voe06(發料料號)在ERP的BOM找的到
             #      #且voe06(發料料號)<>voe15(被替代料號)

             #      #找取替代BOM(abmi6042)
             #      SELECT COUNT(*) INTO l_cnt
             #        FROM bmd_file
             #       WHERE (bmd08 = l_voe.voe09 OR bmd08 = 'ALL' )#主件編號
             #         AND bmd04 = l_voe.voe06 #取代替代料件編號 
             #         AND bmd01 = l_voe.voe15 #原始料件編號
             #         AND (bmd05 <=g_sfb.sfb071 #加上生/失效日
             #              OR bmd05 IS NULL) 
             #         AND (bmd06 > g_sfb.sfb071
             #              OR bmd06 IS NULL)
             #      IF l_cnt = 0 THEN
             #          CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
             #          CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
             #          LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED," ",
             #                      l_msg_bmb03 CLIPPED,':',l_sfa.sfa03 CLIPPED
             #          #此料件不存在BOM或取代替BOM�!
             #          CALL cl_err(l_msg,'aps-036',1)
             #          RETURN
             #      ELSE
             #          LET l_sfa.sfa27 = l_voe.voe06
             #          LET l_sfa.sfa26 = '0'
             #          #再用原始料件編號反推abmi600
             #          #找BOM(abmi600)
             #          SELECT * INTO l_bmb.*
             #            FROM bmb_file
             #           WHERE bmb01 = l_voe.voe09 
             #             AND bmb03 = l_voe.voe15
             #             AND (bmb04 <=g_sfb.sfb071
             #                  OR bmb04 IS NULL) 
             #             AND (bmb05 > g_sfb.sfb071
             #                  OR bmb05 IS NULL)
             #             AND bmb29 = ' ' 
             #          IF STATUS THEN
             #              CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
             #              CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
             #              LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED," ",
             #                          l_msg_bmb03 CLIPPED,':',l_voe.voe15 CLIPPED
             #              #此料件不存在BOM或取代替BOM�!
             #              CALL cl_err(l_msg,'aps-036',1)
             #              RETURN
             #          END IF
             #      END IF
             #  END IF
             ##MOD-B20145---add----end--
             #  SELECT ima25 INTO l_ima25
             #    FROM ima_file
             #   WHERE ima01 = l_sfa.sfa03
             #  LET l_factor = 1
             #  #庫存->發料單位換算率
             #  CALL s_umfchk(l_sfa.sfa03,l_ima25,l_bmb.bmb10) 
             #       RETURNING l_flag,l_factor
             #  IF l_flag = 1 THEN
             #     LET l_factor = 1
             #  END IF
             #  LET l_sfa.sfa04 = l_voe.voe12 * l_factor   #原發數量,預計領用量
             #  LET l_sfa.sfa05 = l_voe.voe12 * l_factor   #應發數量,預計領用量
             #  #FUN-9A0028---add-----end-----
             #  IF l_bmb.bmb09 IS NOT NULL THEN
             #      LET g_opseq =l_bmb.bmb09
             #      LET g_offset=l_bmb.bmb18
             #  END IF
             #  #-->無製程序號
             #  IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
             #  IF g_offset IS NULL THEN LET g_offset=0 END IF
             #  LET l_sfa.sfa08 =g_opseq  #作業編號 
             #  LET l_sfa.sfa09 =g_offset #前置時間調整 
             #  CALL p820_get_sfa11(l_sfa.sfa03,l_sfb39,l_bmb.bmb14) RETURNING l_sfa.sfa11 #來源碼 #CHI-980013 add l_bmb.bmb14
             #  LET l_sfa.sfa12 =l_bmb.bmb10
             #  LET l_sfa.sfa13 =l_bmb.bmb10_fac
             #  SELECT ima86 INTO l_ima86
             #    FROM ima_file
             #   WHERE ima01=l_sfa.sfa03
             #  LET l_sfa.sfa14 =l_ima86
             #  LET l_sfa.sfa15 =l_bmb.bmb10_fac2
             #  LET l_sfa.sfa16 =l_bmb.bmb06
             #  LET l_sfa.sfa161=l_sfa.sfa05/g_sfb.sfb08 #重計實際QPA 
             #  LET l_sfa.sfa25 =0
             # #LET l_sfa.sfa26 =l_bmb.bmb16 #FUN-9B0077 mark
             # #LET l_sfa.sfa27 =l_voe.voe15 #FUN-9B0077 mark
             #  LET l_sfa.sfa28 =1
             #  LET l_sfa.sfa29 =l_sfa.sfa03
             #  LET l_sfa.sfaacti ='Y'
             #  LET l_sfa.sfa100 =l_bmb.bmb28
             #  IF cl_null(l_sfa.sfa100) THEN
             #     LET l_sfa.sfa100 = 0
             #  END IF
#-------------------------------
             #  IF l_sfa.sfa11 = 'X' THEN LET l_sfa.sfa05 = 0 LET l_sfa.sfa161 = 0 END IF  #CHI-980013 
             #FUN-B30121---mark---end---

                #FUN-B30121---add----str---
                IF l_voe.voe06 = l_voe.voe15 THEN
                    LET l_cnt = 0
                    SELECT COUNT(*) INTO l_cnt 
                      FROM voe_file
                     WHERE voe00 = g_plant
                       AND voe01 = g_vod01
                       AND voe02 = g_vod02
                       AND voe03 = l_voe03
                       AND voe15 <> voe06
                       AND voe15 = l_voe.voe15
                    IF l_cnt >=1 THEN
                        LET l_type = '2' #主料
                    ELSE
                        LET l_type = '1' #無取替代狀況
                    END IF
                    #找BOM(abmi600)
                    SELECT COUNT(*) INTO l_cnt
                      FROM bmb_file
                     WHERE bmb01 = l_voe.voe09 
                       AND bmb03 = l_sfa.sfa03
                       AND (bmb04 <=g_sfb.sfb071
                            OR bmb04 IS NULL) 
                       AND (bmb05 > g_sfb.sfb071
                            OR bmb05 IS NULL)
                       AND bmb29 = ' ' 
                    IF l_cnt = 0 THEN
                        #此料件不存在BOM�!
                        CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
                        CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
                        LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED," ",
                                    l_msg_bmb03 CLIPPED,':',l_sfa.sfa03 CLIPPED
                        CALL cl_err(l_msg,'aqc-050',1)
                        RETURN
                    END IF

                   #FUN-B60149 add str----------------------------
                    SELECT MAX(bmb02) INTO l_mbmb02
                      FROM bmb_file
                     WHERE bmb01 = l_voe.voe09
                       AND bmb03 = l_sfa.sfa03
                       AND (bmb04 <=g_sfb.sfb071
                            OR bmb04 IS NULL)
                       AND (bmb05 > g_sfb.sfb071
                            OR bmb05 IS NULL)
                       AND bmb29 = ' '
                       AND bmb04 IN (
                                     SELECT MAX(bmb04)
                                       FROM bmb_file
                                      WHERE bmb01 = l_voe.voe09
                                        AND bmb03 = l_sfa.sfa03
                                        AND (bmb04 <=g_sfb.sfb071
                                             OR bmb04 IS NULL)
                                        AND (bmb05 > g_sfb.sfb071
                                             OR bmb05 IS NULL)
                                        AND bmb29 = ' ' )
                   #FUN-B60149 add end----------------------------

                    SELECT * INTO l_bmb.*
                      FROM bmb_file
                     WHERE bmb01 = l_voe.voe09 
                       AND bmb03 = l_sfa.sfa03
                       AND (bmb04 <=g_sfb.sfb071
                            OR bmb04 IS NULL) 
                       AND (bmb05 > g_sfb.sfb071
                            OR bmb05 IS NULL)
                       AND bmb29 = ' ' 
                       AND bmb02 = l_mbmb02  #FUN-B60149 add
                ELSE
                    LET l_type = '3'     #取替代
                END IF
                SELECT * INTO l_ima.*
                  FROM ima_file
                 WHERE ima01 = l_sfa.sfa03
                IF l_bmb.bmb09 IS NOT NULL THEN
                    LET g_opseq =l_bmb.bmb09
                    LET g_offset=l_bmb.bmb18
                END IF
                #-->無製程序號
                IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
                IF g_offset IS NULL THEN LET g_offset=0 END IF
                LET l_sfa.sfa08 =g_opseq  #作業編號 
                LET l_sfa.sfa09 =g_offset #前置時間調整 
                LET l_sfa.sfa100 =l_bmb.bmb28
                IF cl_null(l_sfa.sfa100) THEN
                   LET l_sfa.sfa100 = 0
                END IF
                CALL p820_get_sfa11(l_sfa.sfa03,l_sfb39,l_bmb.bmb14) RETURNING l_sfa.sfa11 
                LET l_sfa.sfa14 =l_ima.ima86
                LET l_sfa.sfa25 = l_sfa.sfa05
                LET l_sfa.sfa27 =l_voe.voe15 
                LET l_sfa.sfa29 =l_voe.voe09 
                LET l_sfa.sfa30 =l_bmb.bmb25
                LET l_sfa.sfa31 =l_bmb.bmb26
                LET l_sfa.sfa32 ='N'

                LET l_bml04=NULL
                DECLARE bml_cur CURSOR FOR
                SELECT bml04,bml03 FROM bml_file
                 WHERE bml01 = l_sfa.sfa27 
                   AND (bml02=g_sfb.sfb05 OR bml02='ALL')
                   ORDER BY bml03
                FOREACH bml_cur INTO l_bml04,l_bml03
                   EXIT FOREACH                  
                END FOREACH                      
                LET l_sfa.sfa36 = l_bml04

                LET l_sfa.sfaacti ='Y'

                IF l_type = '3' THEN
                    #==>取替代
                    LET l_sfa.sfa12 =l_ima.ima63
                    LET l_sfa.sfa13 =l_ima.ima63_fac
                    LET l_sfa.sfa15 =l_ima.ima86_fac
                    LET l_sfa.sfa16 =0
                    LET l_sfa.sfa161=0
                    IF l_sfa.sfa11 = 'X' THEN 
                        LET l_sfa.sfa05 = 0 
                        LET l_sfa.sfa161 = 0 
                    END IF  
      
                    IF l_main_sfa26 = '3' THEN
                        LET l_sfa.sfa26 = 'U' 
                    ELSE
                        LET l_sfa.sfa26 = 'S' 
                    END IF
                    SELECT COUNT(*) INTO l_cnt
                      FROM bmd_file
                     WHERE (bmd08 = l_voe.voe09 OR bmd08 = 'ALL' )#主件編號
                       AND bmd04 = l_voe.voe06 #取代替代料件編號
                       AND bmd01 = l_voe.voe15 #原始料件編號
                       AND (bmd05 <=g_sfb.sfb071 #加上生/失效日
                            OR bmd05 IS NULL)
                       AND (bmd06 > g_sfb.sfb071
                            OR bmd06 IS NULL)
                    IF l_cnt = 0 THEN
                        CALL cl_get_feldname('bmb01',g_lang) RETURNING l_msg_bmb01
                        CALL cl_get_feldname('bmb03',g_lang) RETURNING l_msg_bmb03
                        LET l_msg = l_msg_bmb01 CLIPPED,':',l_voe.voe09 CLIPPED,
                                    l_msg_bmb03 CLIPPED,':',l_sfa.sfa03 CLIPPED
                        #此料件不存在取替代BOM�!
                        CALL cl_err(l_msg,'aps-105',1)
                        RETURN
                    ELSE
                        SELECT bmd07 INTO l_bmd07
                          FROM bmd_file
                         WHERE (bmd08 = l_voe.voe09 OR bmd08 = 'ALL' )#主件編號
                           AND bmd04 = l_voe.voe06 #取代替代料件編號
                           AND bmd01 = l_voe.voe15 #原始料件編號
                           AND (bmd05 <=g_sfb.sfb071 #加上生/失效日
                                OR bmd05 IS NULL)
                           AND (bmd06 > g_sfb.sfb071
                                OR bmd06 IS NULL)
                        LET l_sfa.sfa28 = l_bmd07
                    END IF
                ELSE
                    LET l_sfa.sfa12 =l_bmb.bmb10
                    LET l_sfa.sfa13 =l_bmb.bmb10_fac
                    LET l_sfa.sfa15 =l_bmb.bmb10_fac2
                    LET l_sfa.sfa16 =l_bmb.bmb06/l_bmb.bmb07
                    LET l_sfa.sfa161=l_sfa.sfa05/g_sfb.sfb08 #重計實際QPA 
                    IF l_sfa.sfa11 = 'X' THEN 
                        LET l_sfa.sfa05 = 0 
                        LET l_sfa.sfa161 = 0 
                    END IF  
                    LET l_sfa.sfa28 =1

                    IF l_type = '1' THEN
                        #==>無取替代狀況
                        LET l_sfa.sfa26 =l_bmb.bmb16 
                    ELSE
                        #==>主料
                        IF l_bmb.bmb16 = '1' THEN
                            LET l_sfa.sfa26 = '3'  #新料,已經被取代
                        ELSE
                            LET l_sfa.sfa26 = '4'  #主料,已經被替代
                        END IF
                        LET l_main_sfa26 = l_sfa.sfa26
                    END IF
                END IF
                #FUN-B30121---add----end---
                #FUN-B50022---add----str---
                LET l_sfa.sfaplant = g_plant  #FUN-980006
                LET l_sfa.sfalegal = g_legal  #FUN-980006
               #FUN-B50022---mod---str--
               #LET l_sfa.sfa012 = ' '        #MOD-A60197 add
               #LET l_sfa.sfa013 = 0          #MOD-A60197 add
                LET l_sfa.sfa012 = l_voe.voe012
                IF NOT cl_null(l_voe.voe013) THEN
                    LET l_sfa.sfa013 = l_voe.voe013
                ELSE
                    LET l_sfa.sfa013 = 0
                END IF
               #FUN-B50022---mod---end--
                #FUN-B50022---add----end---
                #FUN-BB0085-add-str--
                LET l_sfa.sfa04 = s_digqty(l_sfa.sfa04,l_sfa.sfa12)
                LET l_sfa.sfa05 = s_digqty(l_sfa.sfa05,l_sfa.sfa12)
                LET l_sfa.sfa07 = s_digqty(l_sfa.sfa07,l_sfa.sfa12)
                LET l_sfa.sfa25 = s_digqty(l_sfa.sfa25,l_sfa.sfa12)
                #FUN-BB0085-add-end--
                INSERT INTO sfa_file VALUES(l_sfa.*)
                IF SQLCA.SQLCODE THEN    #Duplicate
                    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
                        #因為相同的料件可能有不同的發料單位, 故宜換算之
                        SELECT sfa13 INTO l_sfa13
                          FROM sfa_file
                         WHERE sfa01=g_sfb01
                           AND sfa03=l_bmb.bmb03
                           AND sfa08=g_opseq
                        LET l_sfa13=l_bmb.bmb10_fac/l_sfa13
                       #TQC-B70121--mod---str---
                       #LET l_total=l_total*l_sfa13
                       #LET l_total2=l_total2*l_sfa13
                        LET l_total=l_sfa.sfa04*l_sfa13
                        LET l_total2=l_sfa.sfa05*l_sfa13
                       #TQC-B70121--mod---end---
                         #CHI-980013--begin--add-
                        SELECT sfa11 INTO l_sfa11_a FROM sfa_file
                         WHERE sfa01=g_sfb01
                           AND sfa03=l_bmb.bmb03
                           AND sfa08=g_opseq 
                           AND sfa12=l_bmb.bmb10
                           AND sfa27 =l_voe.voe15
                        IF l_sfa11_a = 'X' THEN LET l_total2 = 0 LET l_sfa.sfa161 = 0 END IF
                        #CHI-980013--end--add--
                        LET l_total  = s_digqty(l_total,l_sfa.sfa12)     #FUN-BB0085
                        LET l_total2 = s_digqty(l_total2,l_sfa.sfa12)    #FUN-BB0085
                        UPDATE sfa_file
                           SET sfa04=sfa04+l_total,
                               sfa05=sfa05+l_total2,
                               sfa16=sfa16+l_sfa.sfa16,         
                              #sfa161=l_sfa.sfa161                   #TQC-B70121 mark
                               sfa161=(sfa05+l_total2)/g_sfb.sfb08   #TQC-B70121 add
                         WHERE sfa01=g_sfb01
                           AND sfa03=l_bmb.bmb03
                           AND sfa08=g_opseq 
                           AND sfa12=l_bmb.bmb10
                           AND sfa27 =l_voe.voe15      #No:FUN-870051
                        IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                            CALL cl_err3("upd","sfa_file",g_sfb01,"",STATUS,"","upd sfa:",1)  
                        END IF
                    END IF
               #TQC-990134--mark---str---
               ##行業別---add --begin
               #ELSE
               #   IF NOT s_industry('std') THEN
               #      INITIALIZE l_sfai.* TO NULL
               #      LET l_sfai.sfai01 = l_sfa.sfa01
               #      LET l_sfai.sfai03 = l_sfa.sfa03
               #      LET l_sfai.sfai08 = l_sfa.sfa08
               #      LET l_sfai.sfai12 = l_sfa.sfa12
               #      LET l_sfai.sfai27 = l_sfa.sfa27   #No:FUN-870051
               #      LET l_flag = s_ins_sfai(l_sfai.*,'')
               #   END IF
               ##行業別---add --end--
               #TQC-990134--mark---end---
                END IF
   END FOREACH
   #FUN-B30121---add---str--
   LET g_sql="SELECT * ",
             "  FROM sfa_file ",
             " WHERE sfa01 = '",g_sfb01,"'",
             "   AND sfa02 = '",l_sfb02,"'",
             "   AND sfa26 IN ('3','4') ",
             "   AND sfa27 = sfa03 ",
             "   ORDER BY sfa27"

   PREPARE p820_upd_sfa_p2 FROM g_sql
   DECLARE p820_upd_sfa_d2 CURSOR FOR p820_upd_sfa_p2
   INITIALIZE l_sfa.* TO NULL
   FOREACH p820_upd_sfa_d2 INTO l_sfa.*
           SELECT SUM(sfa05/sfa28) 
             INTO l_sfa25
             FROM sfa_file
            WHERE sfa01 = g_sfb01
              AND sfa02 = l_sfb02
              AND sfa27 = l_sfa.sfa27
              AND sfa03 <> l_sfa.sfa27
           LET l_sfa161 = (l_sfa.sfa05 + l_sfa25)/g_sfb.sfb08
           LET l_sfa25 = s_digqty(l_sfa25,l_sfa.sfa12)          #FUN-BB0085
           UPDATE sfa_file
              SET sfa161 = l_sfa161,
                  sfa04  = l_sfa.sfa05 + l_sfa25
             WHERE sfa01 = l_sfa.sfa01
               AND sfa03 = l_sfa.sfa03
               AND sfa08 = l_sfa.sfa08
               AND sfa12 = l_sfa.sfa12
               AND sfa27 = l_sfa.sfa27
   END FOREACH
   #FUN-B30121---add---end--
END FUNCTION 

FUNCTION p820_get_sfa11(l_ima01,l_sfb39,l_bmb14)  #CHI-980013
   DEFINE l_ima01  LIKE ima_file.ima01
   DEFINE l_ima08  LIKE ima_file.ima08
   DEFINE l_ima70  LIKE ima_file.ima70
   DEFINE l_sfa11  LIKE sfa_file.sfa11
   DEFINE l_sfb39  LIKE sfb_file.sfb39
   DEFINE l_bmb14  LIKE bmb_file.bmb14   #CHI-980013

   SELECT ima08,ima70 INTO l_ima08,l_ima70
     FROM ima_file
    WHERE ima01 = l_ima01

   LET l_sfa11='N'
   IF l_ima08='R' THEN #來源碼
       LET l_sfa11='R'
   ELSE
       IF l_ima70='Y' THEN #消耗料件否
           LET l_sfa11='E'
       ELSE 
           IF l_ima08 MATCHES '[UV]' THEN #來源碼
               LET l_sfa11=l_ima08
           END IF
       END IF 
   END IF
   IF l_bmb14 = '1' THEN    #CHI-980013
      LET l_sfa11= 'X'      #CHI-980013
   END IF                   #CHI-980013
#FUN-B50022---add-----str--
   IF l_bmb14 = '2' THEN    #FUN-9C0040
      LET l_sfa11 = 'S'     #FUN-9C0040
   END IF                   #FUN-9C0040
   IF l_bmb14 = '3' THEN    #FUN-A30093
      LET l_sfa11 = 'C'     #FUN-A30093
   END IF                   #FUN-A30093	
#FUN-B50022---add-----str--
   IF l_sfb39='2' THEN #完工方式
       LET l_sfa11='E' 
   END IF
   RETURN l_sfa11
END FUNCTION


FUNCTION p820_b_fill()                 #單身填充
    DEFINE l_sql      LIKE type_file.chr1000
    DEFINE l_factor   LIKE vod_file.vod29   #FUN-870013 add
    DEFINE l_cnt      LIKE type_file.num5  #FUN-870013 add

       #FUN-880010  add ima67, vod39
      #LET l_sql = "SELECT 'Y',ima67 planner,vod09,ima02,ima021,ima08,vod16,vod28,'',vod10,vod11,vod35,'',vod03, vod39 route ",       #TQC-860035 add #FUN-870013 mod #FUN-9B0091 mark
       LET l_sql = "SELECT 'Y',ima67 planner,vod09,ima02,ima021,ima08,vod16,vod28,'',vod10,vod11,vod04,vod35,'',vod03, vod39 route ", #TQC-860035 add #FUN-870013 mod #FUN-9B0091 add
                   "  ,vod20,vod41,''  ",  #FUN-930118 ADD  #FUN-BA0032 add
                   "  FROM vod_file,OUTER ima_file ",
                   " WHERE vod00 = '",g_plant,"'",
                   "   AND vod01 = '",g_vod01,"'",
                   "   AND vod02 = '",g_vod02,"'",
                   "   AND vod09 = ima_file.ima01 ",
                   "   AND vod08 = '1' ",  #TQC-860035 add
                   "   AND (vod37 = 'N' ", #未拋轉至工單的才能產生 #FUN-870013 add
                   "    OR vod37 IS NULL OR vod37 = ' ') ", #TQC-870030-(1)add 因為 APS並不會給vod37值
                   "   AND ",g_wc CLIPPED

       #FUN-930149 mark  --str--
       ##FUN-880024---add---str--
       #IF g_sfb.sfb02 = '7' THEN 
       #    #委外工單
       #            LET l_sql = l_sql CLIPPED,"   AND vod03 IN "
       #ELSE
       #    #一般工單
       #            LET l_sql = l_sql CLIPPED,"   AND vod03 NOT IN "
       #END IF
       #LET l_sql = l_sql CLIPPED," (SELECT voo03 FROM voo_file ",
       #                          "   WHERE voo00 = '",g_plant,"'",
       #                          "     AND voo01 = '",g_vod01,"'",
       #                          "     AND voo02 = '",g_vod02,"'",
       #                          " )"
       ##FUN-880024---add---end--
       #FUN-930149  mark  --end--

       #FUN-930149  ADD  --STR--
       IF g_sfb.sfb02 = '7' THEN
         #委外工單
          LET l_sql = l_sql CLIPPED,"   AND vod42 <> 0  "
          CALL cl_set_comp_visible("voo04",TRUE)   #FUN-BA0032 add
       ELSE
         #一般工單
          LET l_sql = l_sql CLIPPED,"   AND vod42 = 0 "
          CALL cl_set_comp_visible("voo04",FALSE)  #FUN-BA0032 add
       END IF
       #FUN-930149  ADD  --END--


       PREPARE p820_prepare FROM l_sql
       MESSAGE " SEARCHING! " 
       DECLARE p820_cur CURSOR FOR p820_prepare
       CALL g_vod.clear()
       LET g_cnt = 1

       FOREACH p820_cur INTO g_vod[g_cnt].*
          IF SQLCA.sqlcode != 0 THEN
             CALL cl_err('foreach:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF

         #FUN-BA0032 add str---
          SELECT voo04 INTO g_vod[g_cnt].voo04
            FROM voo_file
           WHERE voo00 = g_plant
             AND voo01 = g_vod01
             AND voo02 = g_vod02
             AND voo03 = g_vod[g_cnt].vod03
         #FUN-BA0032 add end---

          #FUN-880024 ---add---str
           IF g_vod[g_cnt].ima08 = 'X' THEN
               LET g_vod[g_cnt].select = 'N'
           END IF
          #FUN-880024 ---add---end
          #FUN-870013---add----str---
          LET l_factor = 1
          #庫存/生產單位換算率
          CALL s_umfchk(g_vod[g_cnt].vod09,g_vod[g_cnt].vod28,g_vod[g_cnt].vod16) 
               RETURNING l_cnt,l_factor
          IF l_cnt = 1 THEN
             LET l_factor = 1
          END IF
          LET g_vod[g_cnt].vod29     = l_factor
         #LET g_vod[g_cnt].vod35_pro = g_vod[g_cnt].vod35 * l_factor #FUN-9A0028 mark
          LET g_vod[g_cnt].vod35_pro = g_vod[g_cnt].vod35            #FUN-9A0028 add
          #FUN-870013---add----end---
          LET g_cnt = g_cnt + 1
          IF g_cnt > g_max_rec THEN
             CALL cl_err( '', 9035, 0 )
             EXIT FOREACH
          END IF
       END FOREACH
       CALL g_vod.deleteElement(g_cnt)
       LET g_cnt = g_cnt - 1 
       DISPLAY g_cnt TO FORMONLY.cnt2  
       LET g_rec_b = g_cnt 
END FUNCTION

FUNCTION p820_b()                          #單身修改
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


   #LET g_forupd_sql = "SELECT vod09,'','',vod10,vod11,vod35,vod03 ",       #TQC-860035 add vod03 #FUN-870013 mod  #FUN-9B0091 mark
    LET g_forupd_sql = "SELECT vod09,'','',vod10,vod11,vod04,vod35,vod03 ", #TQC-860035 add vod03 #FUN-870013 mod  #FUN-9B0091 add
                       "  FROM vod_file ",
                       " WHERE vod00 = '",g_plant,"'",
                       "   AND vod01 = '",g_vod01,"'",
                       "   AND vod02 = '",g_vod02,"'",
                       "   AND vod03 = ? ",
                       "  FOR UPDATE "                   #FUN-B50022 add
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)	 #FUN-B50022 add
    DECLARE p820_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

        LET l_ac_t = 0
        LET l_allow_insert = FALSE
        LET l_allow_delete = FALSE
        INPUT ARRAY g_vod WITHOUT DEFAULTS FROM s_vod.* 
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

                LET g_vod_t.* = g_vod[l_ac].*  #BACKUP
                OPEN p820_bcl USING g_vod_t.vod03

                IF STATUS THEN
                    CALL cl_err("OPEN p820_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH p820_bcl INTO g_vod[l_ac].vod09,l_ima02           ,l_ima021        ,                    #FUN-870013 add
                                       #g_vod[l_ac].vod10,g_vod[l_ac].vod11 ,g_vod[l_ac].vod35 ,g_vod[l_ac].vod03                    #FUN-9B0091 mark
                                        g_vod[l_ac].vod10,g_vod[l_ac].vod11 ,g_vod[l_ac].vod04 ,g_vod[l_ac].vod35 ,g_vod[l_ac].vod03 #FUN-9B0091 add

                END IF
                CALL cl_show_fld_cont()   
                CALL p820_set_entry_b()    #FUN-880024 add
                CALL p820_set_no_entry_b() #FUN-880024 add
            END IF  
        BEFORE FIELD route
                CALL cl_set_comp_entry('route',FALSE);
        #FUN-880024 add---str---
        BEFORE FIELD select
                CALL p820_set_no_entry_b() #FUN-880024 add
        AFTER FIELD select
                CALL p820_set_entry_b()    #FUN-880024 add
        #FUN-880024 add---end---

       #BEFORE INSERT
       #    LET p_cmd='a'
       #    LET l_n = ARR_COUNT()
       #    INITIALIZE g_vod[l_ac].* TO NULL      #900423
       #    LET g_vod_t.* = g_vod[l_ac].*         #新輸入資料
       #    CALL cl_show_fld_cont()     
       #    NEXT FIELD vod02

       #AFTER INSERT
       #  #DISPLAY "AFTER INSERT!"  #CHI-A70049 mark
       #   IF INT_FLAG THEN
       #      CALL cl_err('',9001,0)
       #      LET INT_FLAG = 0
       #      CANCEL INSERT
       #   END IF

        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               IF p_cmd = 'u' THEN
                   LET g_vod[l_ac].* = g_vod_t.*
               END IF
               CLOSE p820_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p820_bcl
            COMMIT WORK

        ON ACTION all_yes
            FOR l_i = 1 TO g_rec_b
                IF g_vod[l_i].ima08 <> 'X' THEN
                    LET g_vod[l_i].select = 'Y'
                ELSE
                    LET g_vod[l_i].select = 'N'
                END IF
                DISPLAY BY NAME g_vod[l_i].select
            END FOR 

        ON ACTION all_no
            FOR l_i = 1 TO g_rec_b
                LET g_vod[l_i].select = 'N'
                DISPLAY BY NAME g_vod[l_i].select
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

#TQC-860035----mod-----str---
FUNCTION p820_cre_tmp()          # 建立本程式所有會用到的TEMP TABLE
  DROP TABLE vod_tmp 
#FUN-B50022--mod---str---
  CREATE TEMP TABLE vod_tmp(
                           vod00   LIKE  vod_file.vod00,
                           vod01   LIKE  vod_file.vod01,
                           vod02   LIKE  vod_file.vod02,
                           vod03   LIKE  vod_file.vod03)
#FUN-B50022--mod---end---
END FUNCTION

FUNCTION p820_ins_vod_tmp()
  DEFINE l_i             LIKE type_file.num5

     FOR l_i = 1 TO g_rec_b
          IF g_vod[l_i].select = 'Y' THEN
              INSERT INTO vod_tmp VALUES(g_plant,g_vod01,g_vod02,g_vod[l_i].vod03)
              IF STATUS THEN 
                  CALL cl_err('Ins vod_tmp',STATUS,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211	#FUN-B50022 add
                  EXIT PROGRAM 
              END IF
              LET g_select = g_select + 1
          END IF
     END FOR

END FUNCTION
#TQC-860035----mod-----end---

FUNCTION p820_ins_ecm(p_vof03,p_vof04,p_woq) #FUN-880024 add p_woq
DEFINE l_upd_ecm61  LIKE type_file.chr1  #FUN-960107 add
DEFINE
    p_vof03  LIKE  vof_file.vof03,
    p_vof04  LIKE  vof_file.vof04,
    p_woq    LIKE  sfb_file.sfb08,   #FUN-880024 add
    g_woq    LIKE  sfb_file.sfb08,   #FUN-880024 add
    l_vof    RECORD LIKE vof_file.*, #routing detail file
    l_ecb    RECORD LIKE ecb_file.*, #routing detail file
    l_ecm    RECORD LIKE ecm_file.*, #routing detail file
    l_sgc    RECORD LIKE sgc_file.*, #routing detail file
    l_sgd    RECORD LIKE sgd_file.*,  #routing detail file
    l_vmn    RECORD LIKE vmn_file.*,     #FUN-990008 add
    l_vop    RECORD LIKE vop_file.*,     #FUN-960107 ADD
    l_vnd    RECORD LIKE vnd_file.*,     #FUN-960107 ADD
    l_vom    RECORD LIKE vom_file.*,     #FUN-960107 ADD
    l_eca06  LIKE eca_file.eca06,        #FUN-960107 ADD
    l_von    RECORD LIKE von_file.*,     #FUN-960107 ADD
    l_vnd03  LIKE type_file.num5,        #FUN-960107 ADD
    l_vne03  LIKE type_file.num5,        #FUN-960107 ADD
    l_ecm50  LIKE ecm_file.ecm50,        #FUN-960107 ADD
    l_ecm51  LIKE ecm_file.ecm51,        #FUN-960107 ADD
    l_vof08  LIKE vof_file.vof08,        #FUN-960107 ADD
    l_vof09  LIKE vof_file.vof09,        #FUN-960107 ADD
    l_vom09  DATETIME YEAR TO MINUTE,    #FUN-960107 ADD
    l_vom10  DATETIME YEAR TO MINUTE,    #FUN-960107 ADD
    l_vop09  DATETIME YEAR TO MINUTE,    #FUN-960107 ADD
    l_vop10  DATETIME YEAR TO MINUTE,    #FUN-960107 ADD
    l_vnd07  DATETIME YEAR TO MINUTE,    #FUN-960107 ADD
    l_vnd08  DATETIME YEAR TO MINUTE     #FUN-960107 ADD


   LET g_woq = p_woq #FUN-880024 add

   LET g_sql="SELECT * ",
             "  FROM vof_file ",
             " WHERE vof00 = '",g_plant,"'",
             "   AND vof01 = '",g_vod01,"'",
             "   AND vof02 = '",g_vod02,"'",
             "   AND vof03 = '",p_vof03,"'", #mo_id
             "   AND vof04 = '",p_vof04,"'", #route_id
             " ORDER BY vof05 "

   PREPARE p820_ins_ecm_p FROM g_sql
   DECLARE p820_ins_ecm_d CURSOR FOR p820_ins_ecm_p
    LET g_cnt=0
    FOREACH p820_ins_ecm_d INTO l_vof.*
        IF SQLCA.sqlcode THEN EXIT FOREACH END IF
        INITIALIZE l_ecm.* TO NULL  
        INITIALIZE l_ecb.* TO NULL #FUN-880024 add
        LET l_ecm.ecm01      =  g_sfb.sfb01
        LET l_ecm.ecm02      =  g_sfb.sfb02
        LET l_ecm.ecm03_par  =  g_sfb.sfb05
        LET l_ecm.ecm03      =  l_vof.vof05
        LET l_ecm.ecm04      =  l_vof.vof06
        LET l_ecm.ecm012 = l_vof.vof012 #FUN-B50022 add
        #FUN-880024 add---str---
         SELECT * 
           INTO l_ecb.*
           FROM ecb_file
          WHERE ecb01 = g_sfb.sfb05
            AND ecb02 = p_vof04
            AND ecb03 = l_ecm.ecm03
            AND ecb012 = l_ecm.ecm012 #FUN-B50022 add
        #FUN-880024 add---end---
        IF g_vlz.vlz60 = 1 THEN 
            #1:機器編號
            LET l_ecm.ecm05      =  l_vof.vof11 #機器編號
            LET l_ecm.ecm06      =  l_vof.vof17 #工作站  #FUN-960107 mod
        ELSE
            #0:工作站
            LET l_ecm.ecm05      =  NULL         #機器編號
            LET l_ecm.ecm06      =  l_vof.vof11  #工作站
        END IF

        LET l_ecm.ecm07      =  0           
        LET l_ecm.ecm08      =  0           
        LET l_ecm.ecm09      =  0           
        LET l_ecm.ecm10      =  0           
        LET l_ecm.ecm11      =  l_vof.vof04          #製程編號
       #FUN-960107 MOD --STR-----------------------------------------
       #090901 還原
        LET l_ecm.ecm13      =  l_ecb.ecb18          #固定工時(秒) 
        LET l_ecm.ecm14      =  l_ecb.ecb19*g_woq    #標準工時(秒)
        LET l_ecm.ecm15      =  l_ecb.ecb20          #固定機時(秒)
        LET l_ecm.ecm16      =  l_ecb.ecb21*g_woq    #標準機時(秒)
       #LET l_eca06 = NULL
       #SELECT eca06 INTO l_eca06
       #  FROM eca_file
       # WHERE eca01 = l_ecm.ecm06
       #IF l_eca06 = '1' THEN 
       #   #機器產能
       #   LET l_ecm.ecm13 = 0
       #   LET l_ecm.ecm14 = 0
       #   LET l_ecm.ecm15 = l_vof.vof20
       #   LET l_ecm.ecm16 = l_vof.vof21 * g_sfb.sfb08
       #ELSE
       #   #人工產能
       #   LET l_ecm.ecm13 = l_vof.vof20
       #   LET l_ecm.ecm14 = l_vof.vof21 * g_sfb.sfb08
       #   LET l_ecm.ecm15 = 0
       #   LET l_ecm.ecm16 = 0
       #END IF 
       #FUN-960107 MOD --END----------------------------------------

        LET l_ecm.ecm49      =  l_ecb.ecb38*g_woq    #製程人力
        LET l_ecm.ecm45      =  l_ecb.ecb17          #作業名稱
        LET l_ecm.ecm50      =  l_vof.vof08          #
        LET l_ecm.ecm51      =  l_vof.vof09
        LET l_ecm.ecm52      =  l_ecb.ecb39          #SUB 否
        LET l_ecm.ecm53      =  l_ecb.ecb40          #PQC 否
        LET l_ecm.ecm54      =  l_ecb.ecb41          #Check in 否
        LET l_ecm.ecm55      =  l_ecb.ecb42          #Check in Hold 否
        LET l_ecm.ecm56      =  l_ecb.ecb43          #Check Out Hold 否
       #------>
        LET l_ecm.ecm291     =  0           
        LET l_ecm.ecm292     =  0           
        LET l_ecm.ecm301     =  0           
        LET l_ecm.ecm302     =  0           
        LET l_ecm.ecm303     =  0           
        LET l_ecm.ecm311     =  0           
        LET l_ecm.ecm312     =  0           
        LET l_ecm.ecm313     =  0           
        LET l_ecm.ecm314     =  0           
        LET l_ecm.ecm315     =  0           #bonus
        LET l_ecm.ecm316     =  0           #bonus
        LET l_ecm.ecm321     =  0           
        LET l_ecm.ecm322     =  0           
       #------>
        LET l_ecm.ecm57      = l_ecb.ecb44
        LET l_ecm.ecm58      = l_ecb.ecb45
        LET l_ecm.ecm59      = l_ecb.ecb46
        #FUN-960107---add---str---
        IF l_vof.vof14 = 1 THEN
            LET l_ecm.ecm61 = 'Y'
        ELSE
            LET l_ecm.ecm61 = 'N'
        END IF
        #FUN-960107---add---end---
        LET l_ecm.ecmacti    =  'Y'           
        LET l_ecm.ecmuser    =  g_user         
        LET l_ecm.ecmgrup    =  g_grup        
        LET l_ecm.ecmmodu    =  ''           
        LET l_ecm.ecmdate    =  g_today 
      #TQC-990134--mark---str----
      ##industry--Begin                                                                                                             
      # IF s_industry('slk') THEN
      #   LET l_ecm.ecmslk01  = l_ecb.ecbslk01
      #   LET l_ecm.ecmslk02  = l_ecb.ecbslk02*g_woq 
      #   LET l_ecm.ecmslk03  = l_ecb.ecbslk04
      #   LET l_ecm.ecmslk04  = l_ecb.ecbslk05
      # END IF
      ##industry--End     
      #TQC-990134--mark---end----
       
       #FUN-960107 ADD --STR--------------------------
       #==>委外製程
        INITIALIZE l_vop.* TO NULL  
        SELECT vop00,
               vop01,vop02,vop03,vop04,vop05,
               vop06,vop07,vop08,vop09,vop10,
               vop11,vop12,vop13,vop14,vop15
          INTO l_vop.vop00,
               l_vop.vop01,l_vop.vop02,l_vop.vop03,l_vop.vop04,l_vop.vop05,
               l_vop.vop06,l_vop.vop07,l_vop.vop08,l_vop09    ,l_vop10    ,
               l_vop.vop11,l_vop.vop12,l_vop.vop13,l_vop.vop14,l_vop.vop15
          FROM vop_file 
         WHERE vop00 = l_vof.vof00
           AND vop01 = l_vof.vof01
           AND vop02 = l_vof.vof02
           AND vop03 = l_vof.vof03
           AND vop05 = l_vof.vof05
           AND vop06 = l_vof.vof06
           AND vop012 = l_vof.vof012 #FUN-B50022 add

       #==>一般製程
        INITIALIZE l_vom.* TO NULL  
        SELECT vom00,
               vom01,vom02,vom03,vom04,vom05,
               vom06,vom07,vom08,vom09,vom10,
               vom11,vom12,vom13,vom14
          INTO l_vom.vom00,
               l_vom.vom01,l_vom.vom02,l_vom.vom03,l_vom.vom04,l_vom.vom05,
               l_vom.vom06,l_vom.vom07,l_vom.vom08,l_vom09    ,l_vom10,
               l_vom.vom11,l_vom.vom12,l_vom.vom13,l_vom.vom14
          FROM vom_file
         WHERE vom00 = l_vof.vof00
           AND vom01 = l_vof.vof01
           AND vom02 = l_vof.vof02
           AND vom03 = l_vof.vof03
           AND vom04 = l_vof.vof04
           AND vom05 = l_vof.vof05
           AND vom06 = l_vof.vof06
           AND vom12 = 0 #是否為鎖定設備 0:否 1:是
           AND vom012 = l_vof.vof012 #FUN-B50022 add

        IF NOT cl_null(l_vop.vop00) THEN
            LET l_ecm.ecm52 = 'Y'
            #製程外包(ecm52='Y')
            #工作站不會給值,
            #(1)工作站(ecm06)預設=>aeci620作業編號預設的工作站(ecd07)
            #(2)機器編號(ecm05)預設=>vof11(資源編號)
            SELECT ecd07 
              INTO l_ecm.ecm06 
              FROM ecd_file
             WHERE ecd01 = l_ecm.ecm04
           #LET l_ecm.ecm05 = l_vof.vof11 #FUN-9A0047 mark
            LET l_ecm.ecm05 = NULL        #FUN-9A0047 add
        ELSE
            LET l_ecm.ecm52 = 'N'
        END IF
       #FUN-960107 ADD --END---------------------------	

        #FUN-B50022---add----str---
        LET l_ecm.ecmplant = g_plant    #FUN-980006
        LET l_ecm.ecmlegal = g_legal    #FUN-980006
        LET l_ecm.ecmoriu = g_user      #No.FUN-980030 10/01/04
        LET l_ecm.ecmorig = g_grup      #No.FUN-980030 10/01/04
        LET l_ecm.ecm62 = l_ecb.ecb46
        LET l_ecm.ecm63 = l_ecb.ecb51
        LET l_ecm.ecm12 = l_ecb.ecb52
        LET l_ecm.ecm64 = l_ecb.ecb53
        LET l_ecm.ecm34 = l_ecb.ecb14
        LET l_ecm.ecm65 = 0
        LET l_ecm.ecm66 = l_ecb.ecb66  
        IF cl_null(l_ecm.ecm66) THEN 
           #LET l_ecm.ecm66 = 'N'     #CHI-B80096  mark
            LET l_ecm.ecm66 = 'Y'     #CHI-B80096      
        END IF
        LET l_ecm.ecm67 = l_ecb.ecb25 
        #FUN-B50022---add----end---
        IF cl_null(l_ecm.ecm62) OR l_ecm.ecm62 = 0 THEN LET l_ecm.ecm62 = 1 END IF  #CHI-B80096
        IF cl_null(l_ecm.ecm63) OR l_ecm.ecm63 = 0 THEN LET l_ecm.ecm63 = 1 END IF  #CHI-B80096       
        INSERT INTO ecm_file VALUES(l_ecm.*)
        IF SQLCA.SQLCODE AND ( NOT cl_sql_dup_value(SQLCA.SQLCODE) ) THEN 
            CALL cl_err3("ins","ecm_file","","",STATUS,"","",1) 
            LET g_success = 'N'
            EXIT FOREACH 
       #FUN-960107 ADD --STR---------------------------
        ELSE
           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN 
               #==>更新ecm50,ecm51
               SELECT MIN(vof08),MAX(vof09) 
                 INTO l_ecm50,l_ecm51
                 FROM vof_file
                WHERE vof00 = g_plant
                  AND vof01 = g_vod01
                  AND vof02 = g_vod02
                  AND vof03 = p_vof03
                  AND vof04 = p_vof04
               UPDATE ecm_file
                  SET ecm50 = l_ecm50,
                      ecm51 = l_ecm51
                WHERE ecm01 = l_ecm.ecm01
                  AND ecm03 = l_ecm.ecm03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("update","ecm_file",l_ecm.ecm01,l_ecm.ecm03,SQLCA.sqlcode,"","",1)
                   LET g_success = 'N'
                   EXIT FOREACH 
               END IF
               EXIT FOREACH #因為鎖定設備,會有重覆的vof_file資料,所以更新ecm50,ecm51後即離開FOREACH
           END IF
           #委外製程==>
           IF NOT cl_null(l_vop.vop00) THEN 
              LET l_vnd.vnd01 = l_ecm.ecm01
              LET l_vnd.vnd02 = l_ecm.ecm01
              LET l_vnd.vnd03 = l_vop.vop05
              LET l_vnd03     = l_vop.vop05
              LET l_vnd.vnd04 = l_vop.vop06
              LET l_vnd.vnd05 = ' '
              IF l_vop.vop08 = 1 THEN #外包類型
                 LET l_vnd.vnd06 = 0
                 LET l_vnd.vnd11 = l_vop.vop11
              ELSE
                 LET l_vnd.vnd06 = 3
                 LET l_vnd.vnd11 = ''
              END IF
              IF l_vop.vop08 = 2 THEN
                 LET l_vnd07 = l_vop09
                 LET l_vnd08 = l_vop10
              ELSE
                 LET l_vnd07 = ''
                 LET l_vnd08 = ''
              END IF
              LET l_vnd.vnd09 = 1
              LET l_vnd.vnd10 = 0
              LET l_vnd.vnd012 = l_vof.vof012
              INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,
                                   vndlegal,vndplant,vnd012) #FUN-B50022 add
               VALUES(l_vnd.vnd01,l_vnd.vnd02,l_vnd03,l_vnd.vnd04,l_vnd.vnd05,
                      l_vnd.vnd06,l_vnd07    ,l_vnd08,l_vnd.vnd09,l_vnd.vnd10,
                      l_vnd.vnd11,
                      g_legal,g_plant,l_vnd.vnd012) #FUN-B50022 add
              IF STATUS THEN
                 CALL cl_err3("ins","vnd_file","","",STATUS,"","",1)
                 LET g_success = 'N'
                 EXIT FOREACH
              END IF
           END IF

           #一般製程==>
           IF NOT cl_null(l_vom.vom00) THEN
               LET l_vnd.vnd01 = l_ecm.ecm01
               LET l_vnd.vnd02 = l_ecm.ecm01
               LET l_vnd.vnd03 = l_vom.vom05
               LET l_vnd03     = l_vom.vom05
               LET l_vnd.vnd04 = l_vom.vom06
               LET l_vnd.vnd05 = l_vom.vom07
               LET l_vnd.vnd06 = l_vom.vom08
               LET l_vnd07     = l_vom09
               LET l_vnd08     = l_vom10
               LET l_vnd.vnd09 = l_vom.vom11
               LET l_vnd.vnd10 = l_vom.vom12
               LET l_vnd.vnd11 = ''
               LET l_vnd.vndlegal = g_legal    #FUN-B50022 add
               LET l_vnd.vndplant = g_plant    #FUN-B50022 add
               LET l_vnd.vnd012 = l_ecm.ecm012 #FUN-B50022 add
               INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,
                                    vndlegal,vndplant,vnd012) #FUN-B50022 add
                VALUES(l_vnd.vnd01,l_vnd.vnd02,l_vnd03,l_vnd.vnd04,l_vnd.vnd05,
                       l_vnd.vnd06,l_vnd07    ,l_vnd08,l_vnd.vnd09,l_vnd.vnd10, 
                       l_vnd.vnd11,
                       l_vnd.vndlegal,l_vnd.vndplant,l_vnd.vnd012) #FUN-B50022 add
               IF STATUS THEN
                   CALL cl_err3("ins","vnd_file","","",STATUS,"","",1)
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE
                   UPDATE vom_file 
                      SET vom13 = 1 #是否更新，0:否 1:是
                    WHERE vom00 = l_vom.vom00
                      AND vom01 = l_vom.vom01
                      AND vom02 = l_vom.vom02
                      AND vom03 = l_vom.vom03
                      AND vom04 = l_vom.vom04
                      AND vom05 = l_vom.vom05
                      AND vom06 = l_vom.vom06
                      AND vom12 = 0 #是否為鎖定設備，0:否 1:是
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","vom_file","","",STATUS,"","",1)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
               END IF
           END IF

           #一般製程--鎖定設備/鎖定設備時間
           LET g_sql = " SELECT * FROM von_file ", 
                       "  WHERE von00='",l_vof.vof00 CLIPPED,"' ",
                       "    AND von01='",l_vof.vof01 CLIPPED,"' ",
                       "    AND von02='",l_vof.vof02 CLIPPED,"' ",
                       "    AND von03='",l_vof.vof03 CLIPPED,"' ",
                       "    AND von04='",l_vof.vof04 CLIPPED,"' ",
                       "    AND von05='",l_vof.vof05 CLIPPED,"' ",
                       "    AND von06='",l_vof.vof06 CLIPPED,"' ",
                       " ORDER BY von07 "   
           
           PREPARE p820_ins_vndvne FROM g_sql
           DECLARE p820_ins_vndvne_cs CURSOR FOR p820_ins_vndvne          

           INITIALIZE l_von.* TO NULL
           LET l_upd_ecm61 = 'N'
           FOREACH p820_ins_vndvne_cs INTO l_von.*
               IF STATUS THEN 
    	          CALL cl_err('foreach:',STATUS,1)
    	          EXIT FOREACH
               END IF                
               #==>鎖定設備
               #g_sfb.sfb13 #預計開工日
               #g_sfb.sfb15 #預計完工日
               LET l_vne03 = l_von.von05
               SELECT vof08,vof09 
                 INTO l_vof08,l_vof09
                 FROM vof_file
                WHERE vof00 = l_von.von00
                  AND vof01 = l_von.von01
                  AND vof02 = l_von.von02
                  AND vof03 = l_von.von03
                  AND vof04 = l_von.von04
                  AND vof05 = l_von.von05
                  AND vof06 = l_von.von06
                  AND vof11 = l_von.von07
                  AND vof012 = l_von.von012 #FUN-B50022 add
               INSERT INTO vne_file(vne01      ,vne02      ,vne03      ,vne04      ,vne05      ,vne06      ,vne07      ,vne50      ,vne51      ,
                                    vne311     ,vne312     ,vne313     ,vne314     ,vne315     ,vne316     ,  
                                    vnelegal   ,vneplant   ,vne012) #FUN-B50022 add
                             VALUES(l_ecm.ecm01,l_ecm.ecm01,l_vne03,l_von.von06,l_von.von07,l_von.von08,l_von.von09    ,l_vof08    ,l_vof09,
                                    0,0,0,0,0,0,
                                    g_legal,g_plant,l_von.von012)   #FUN-B50022 add
               IF STATUS THEN
                   CALL cl_err3("ins","vne_file","","",STATUS,"","",1)
                   LET g_success = 'N'
                   EXIT FOREACH
               ELSE
                   UPDATE von_file
                      SET von10 = 1
                    WHERE von00 = l_von.von00
                      AND von01 = l_von.von01
                      AND von02 = l_von.von02
                      AND von03 = l_von.von03
                      AND von04 = l_von.von04
                      AND von05 = l_von.von05
                      AND von06 = l_von.von06
                      AND von07 = l_von.von07
                      AND von012 = l_von.von012 #FUN-B50022 add
                   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                      CALL cl_err3("upd","von_file","","",STATUS,"","",1)
                      LET g_success = 'N'
                      EXIT FOREACH
                   END IF
               END IF

               #==>鎖定時間
               INITIALIZE l_vom.* TO NULL     
               SELECT vom00,
                      vom01,vom02,vom03,vom04,vom05,
                      vom06,vom07,vom08,vom09,vom10,
                      vom11,vom12,vom13,vom14,vom012 #FUN-B50022 add vom012
                 INTO l_vom.vom00,
                      l_vom.vom01,l_vom.vom02,l_vom.vom03,l_vom.vom04,l_vom.vom05,
                      l_vom.vom06,l_vom.vom07,l_vom.vom08,l_vom09    ,l_vom10,
                      l_vom.vom11,l_vom.vom12,l_vom.vom13,l_vom.vom14,l_vom.vom012 #FUN-B50022 add vom012
                 FROM vom_file
                WHERE vom00 = l_vof.vof00
                  AND vom01 = l_vof.vof01
                  AND vom02 = l_vof.vof02          
                  AND vom03 = l_vof.vof03          
                  AND vom04 = l_vof.vof04 
                  AND vom05 = l_vof.vof05
                  AND vom06 = l_vof.vof06      
                  AND vom07 = l_von.von07
                  AND vom12 = 1 #1:鎖定設備
                  AND vom012 = l_vof.vof012 #FUN-B50022 add
               IF NOT cl_null(l_vom.vom00) THEN
                   LET l_vnd03 = l_vom.vom05
                   INSERT INTO vnd_file(vnd01,vnd02,vnd03,vnd04,vnd05,vnd06,vnd07,vnd08,vnd09,vnd10,vnd11,
                                        vndlegal,vndplant,vnd012) #FUN-B50022 add
                    VALUES(l_ecm.ecm01,l_ecm.ecm01,l_vnd03,l_vom.vom06,l_vom.vom07,l_vom.vom08,l_vom09,
                           l_vom10,l_vom.vom11,l_vom.vom12,'',
                           g_legal,g_plant,l_vom.vom012) #FUN-B50022 add
                   IF STATUS THEN
                       CALL cl_err3("ins","vnd_file","","",STATUS,"","",1)
                       LET g_success = 'N'
                       EXIT FOREACH 
                   ELSE
                       UPDATE vom_file 
                          SET vom13 = 1
                        WHERE vom00 = l_vom.vom00
                          AND vom01 = l_vom.vom01
                          AND vom02 = l_vom.vom02
                          AND vom03 = l_vom.vom03
                          AND vom04 = l_vom.vom04
                          AND vom05 = l_vom.vom05
                          AND vom06 = l_vom.vom06
                          AND vom07 = l_vom.vom07
                          AND vom12 = 1 #鎖定設備
                          AND vom012 = l_vom.vom012 #FUN-B50022 add
                       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          CALL cl_err3("upd","vom_file","","",STATUS,"","",1)
                          LET g_success = 'N'
                          EXIT FOREACH
                       END IF
                   END IF
               END IF          
               LET l_upd_ecm61 = 'Y'
               INITIALIZE l_von.* TO NULL
           END FOREACH           
           IF g_success != 'N' AND l_upd_ecm61 = 'Y' THEN
               UPDATE ecm_file SET ecm61 = 'Y'
                WHERE ecm01 = l_ecm.ecm01
                  AND ecm03 = l_ecm.ecm03
                  AND ecm012 = l_ecm.ecm012 #FUN-B50022 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                   CALL cl_err3("upd","ecm_file","","",STATUS,"","",1)
                   LET g_success = 'N'
                   RETURN
               END IF
           END IF
        #FUN-960107 ADD --END-------------------------------------------
           #FUN-990008---add-----str----
           #===>aps 途程製程維護檔(vmn_file)
           INSERT INTO vmn_file(vmn01,vmn02,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19,vmnlegal,vmnplant,vmn012,vmn20,vmn21) #FUN-B50101 add vmnlegal,vmnplant,vmn012 #FUN-BA0020 add vmn20,vmn21
                SELECT g_sfb.sfb05,g_sfb.sfb01,vmn03,vmn04,vmn08,vmn081,vmn09,vmn12,vmn13,vmn15,vmn16,vmn17,vmn18,vmn19,g_legal,g_plant,vmn012,l_ecb.ecb19,l_ecb.ecb21 #MOD-940141 ADD  #FUN-B50101 add vmnlegal,vmnplant,vmn012 #FUN-BA0020 add ecb19,ecb21
                  FROM vmn_file
                 WHERE vmn01=g_sfb.sfb05   
                   AND vmn02=g_sfb.sfb06
                   AND vmn03=l_ecm.ecm03
                   AND vmn04=l_ecm.ecm04
                   AND vmn012=l_ecm.ecm012 #製程段號 #FUN-B50101 add
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN       
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","vmn_file(1)","","",STATUS,"","",1) 
                   LET g_success = 'N'
                   EXIT FOREACH 
               ELSE
                   INITIALIZE l_vmn.* TO NULL  
                   LET l_vmn.vmn01  = g_sfb.sfb05
                   LET l_vmn.vmn02  = g_sfb.sfb01
                   LET l_vmn.vmn03  = l_ecm.ecm03
                   LET l_vmn.vmn04  = l_ecm.ecm04
                   LET l_vmn.vmn08  = NULL
                   LET l_vmn.vmn081 = NULL
                   LET l_vmn.vmn09  = 0
                   LET l_vmn.vmn12  = 0
                   LET l_vmn.vmn13  = 1
                   LET l_vmn.vmn15  = 0
                   LET l_vmn.vmn16  = 9999
                   LET l_vmn.vmn17  = 1
                   LET l_vmn.vmn19  = 0
                   #FUN-B50101--add---str---
                   LET l_vmn.vmnlegal = g_legal
                   LET l_vmn.vmnplant = g_plant
                   LET l_vmn.vmn012 = l_ecm.ecm012
                   #FUN-B50101--add---end---
                   INSERT INTO vmn_file VALUES(l_vmn.*)
                   IF STATUS THEN       
                       CALL cl_err3("ins","vmn_file(2)","","",STATUS,"","",1) 
                       LET g_success = 'N'
                       EXIT FOREACH 
                   END IF
               END IF
           END IF
           #FUN-9A0047--add----str----
           #產生vmn_file時,當製程為委外時(ecm52='Y'),則vmn18=vop07(外包商編號)
           IF l_ecm.ecm52 = 'Y' THEN
               UPDATE vmn_file
                  SET vmn18 = l_vop.vop07
                WHERE vmn01 = g_sfb.sfb05
                  AND vmn02 = g_sfb.sfb01
                  AND vmn03 = l_ecm.ecm03
                  AND vmn04 = l_ecm.ecm04
                  AND vmn012 = l_ecm.ecm012 #FUN-B50101 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN       
                   CALL cl_err3("upd","vmn_file(2)","","",SQLCA.sqlcode,"","",1) 
                   LET g_success = 'N'
                   EXIT FOREACH 
               END IF
           END IF
           #FUN-9A0047--add----end----
           #===>APS途程製程指定工具(vnm_file)
           INSERT INTO vnm_file(vnm00,vnm01,vnm02,vnm03,vnm04,vnm05,vnm06,vnmlegal,vnmplant,vnm012)  #FUN-B50022 add legal,plant,vnm012
                SELECT g_sfb.sfb05,g_sfb.sfb01,vnm02,vnm03,vnm04,vnm05,vnm06,g_legal,g_plant,vnm012  #FUN-B50022 add legal,plant,vnm012
                  FROM vnm_file
                 WHERE vnm00 = g_sfb.sfb05  #品號
                   AND vnm01 = g_sfb.sfb06  #替代碼
                   AND vnm02 = l_ecm.ecm03  #加工序號
                   AND vnm012 = l_ecm.ecm012 #FUN-B50022 add
           IF STATUS THEN       
               CALL cl_err3("ins","vnm_file","","",STATUS,"","",1) 
               LET g_success = 'N'
               EXIT FOREACH 
           END IF
           #FUN-990008---add-----end----
        END IF 

    END FOREACH
END FUNCTION

FUNCTION p820_get_vlz()
    SELECT * INTO g_vlz.*
      FROM vlz_file
     WHERE vlz01 = g_vod01
       AND vlz02 = g_vod02
END FUNCTION

#FUN-870013--add---str--
FUNCTION p820_upd_vod(p_vod,p_sfb01)
  DEFINE p_vod	          RECORD LIKE vod_file.*
  DEFINE p_sfb01          LIKE sfb_file.sfb01

  UPDATE vod_file 
     SET vod37 = 'Y',          #拋轉否='Y' #已拋轉
         vod38 = p_sfb01
   WHERE vod00 = p_vod.vod00
     AND vod01 = p_vod.vod01
     AND vod02 = p_vod.vod02
     AND vod03 = p_vod.vod03
  IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","vod_file",p_vod.vod00,p_vod.vod01,SQLCA.sqlcode,"","upd vod_file",1) 
      LET g_success = 'N'
  END IF
END FUNCTION
#FUN-870013--add---str--

#FUN-880024 ---add---str--
FUNCTION p820_set_entry_b()
   CALL cl_set_comp_entry("select",TRUE)    
END FUNCTION

FUNCTION p820_set_no_entry_b()
   IF g_vod[l_ac].ima08 = 'X' THEN
       CALL cl_set_comp_entry("select",FALSE)
   END IF
END FUNCTION
#FUN-880024 ---add---end--
