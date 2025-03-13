# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: asft700_tch2.4gl
# Descriptions...: 觸控螢幕製程移轉作業-選擇工作站(screen02)
# Date & Author..: 99/07/20 By Lilan 
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216

GLOBALS "../../config/top.global"

DEFINE
       g_argv1        LIKE   shb_file.shb05,   #VARCHAR(16)
       g_shb          RECORD LIKE shb_file.*,
       g_ecm          RECORD LIKE ecm_file.*,
       g_eca          RECORD LIKE eca_file.*,
       g_cond         LIKE   ze_file.ze03,     #VARCHAR(10) 
       g_wc,g_wc2     string,                
       g_sql          string,                      
       g_cnt          LIKE type_file.num10,    #INTEGER
       g_rec_b        LIKE type_file.num5,     #SMALLINT
       g_page_num     LIKE type_file.num5

DEFINE g_ima02        LIKE ima_file.ima02      #料件品名
DEFINE g_sfb05        LIKE sfb_file.sfb05      #料件編號
DEFINE g_sfb08        LIKE sfb_file.sfb08      #生產量
DEFINE g_sfb09        LIKE sfb_file.sfb09      #完工量
DEFINE g_gen03        LIKE gen_file.gen03      #User所屬部門
DEFINE p_row,p_col    LIKE type_file.num5      #SMALLINT
DEFINE g_msg          LIKE ze_file.ze03,       #VARCHAR(1500)
       l_ac           LIKE type_file.num5      #目前處理的ARRAY CNT        #SMALLINT
DEFINE g_row_count    LIKE type_file.num10     #INTEGER
DEFINE g_curs_index   LIKE type_file.num10     #INTEGER
DEFINE g_ecm2     DYNAMIC ARRAY OF RECORD
          ecm03       LIKE ecm_file.ecm03,
	  ecm06       LIKE ecm_file.ecm06,
          ecm52       LIKE ecm_file.ecm52           
       END RECORD
DEFINE g_routing  DYNAMIC ARRAY OF RECORD
          title       STRING,
          detail      STRING,
          v1          LIKE type_file.num5,     #在製量
	  v2          LIKE type_file.num5,     #轉入量
       	  v3          LIKE type_file.num5      #轉出量        
       END RECORD
DEFINE g_sfb DYNAMIC ARRAY OF RECORD
          sfb01       LIKE sfb_file.sfb01,
          sfb05       LIKE sfb_file.sfb05,
          ima02       LIKE ima_file.ima02,
          sfb08       LIKE sfb_file.sfb08,
          sfb09       LIKE sfb_file.sfb09,
          ecm03       LIKE ecm_file.ecm03,
          wipqty      LIKE shy_file.shy08,     #在製量
          inqty       LIKE shy_file.shy08,     #轉入量
          outqty      LIKE shy_file.shy08,     #轉出量
          sfb15       LIKE sfb_file.sfb15
      END RECORD
DEFINE g_acthidden    STRING                   #隱藏的按鈕,以","分隔
DEFINE g_act          STRING                   #隱藏的按鈕
DEFINE g_i            LIKE type_file.num5      #記錄現在是哪個ecm ARRAY


MAIN
   DEFINE l_time   LIKE type_file.chr8    #VARCHAR(8)

     OPTIONS
       #FORM LINE     FIRST + 2,               #畫面開始的位置
       #MESSAGE LINE  LAST,                    #訊息顯示的位置
       #PROMPT LINE   LAST,                    #提示訊息的位置
        INPUT NO WRAP                          #輸入的方式:不打轉
     DEFER INTERRUPT                           #擷取中斷鍵

     IF (NOT cl_user()) THEN
        EXIT PROGRAM
     END IF

     WHENEVER ERROR CALL cl_err_msg_log

     IF (NOT cl_setup("ASF")) THEN
       EXIT PROGRAM
     END IF

     LET g_argv1= ARG_VAL(1)
    # CALL cl_used(g_prog,l_time,1) RETURNING l_time          #FUN-B80086   MARK
     CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80086   ADD

     INITIALIZE g_ecm.* TO NULL
     INITIALIZE g_eca.* TO NULL
     INITIALIZE g_shb.* TO NULL

     LET p_row = 1
     LET p_col = 10
     LET g_page_num = 1    
     LET g_win_style = "touch-w1"   #yen

     OPEN WINDOW asft700_tch2_w AT p_row,p_col WITH FORM "asf/42f/asft700_tch2"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 

     CALL cl_ui_init()

     CALL cl_set_act_visible("accept,cancel", FALSE) 
     CALL cl_set_comp_visible("page02",FALSE)           #隱藏工單頁面
     CALL cl_set_comp_visible("Col4,Col6,Col7",FALSE)   #隱藏工單單身不需顯示欄位

     LET g_shb.shb04 = g_user    #開啟畫面時，此欄位預設登入者代號
     CALL t700_tch2_shb04()    

     CALL t700_tch2_getbtndata()
     CALL t700_tch2_i()

     CLOSE WINDOW asft700_tch2_w
    # CALL cl_used(g_prog,l_time,2) RETURNING l_time          #FUN-B80086   MARK 
     CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN


FUNCTION t700_tch2_i()
     DEFINE l_i         LIKE type_file.num5
     DEFINE l_j         LIKE type_file.num5
     DEFINE l_title     DYNAMIC ARRAY OF STRING
     DEFINE l_detail    DYNAMIC ARRAY OF STRING
     #key最多5個，組成字串.每個key以";"分隔
     #kye1=value1;kye2=value2;kye3=value3;kye4=value4;kye5=value5
     DEFINE l_doc_key   DYNAMIC ARRAY OF STRING
     DEFINE l_doc_field DYNAMIC ARRAY OF STRING   #存圖片的欄位
     DEFINE l_s         STRING
     DEFINE l_cmd       STRING

     DISPLAY BY NAME g_shb.shb04,g_shb.shb07,g_shb.shb05,g_shb.shb06

     DIALOG ATTRIBUTES(UNBUFFERED)
	INPUT BY NAME g_shb.shb04,g_shb.shb07,g_shb.shb05,g_shb.shb06 
            ATTRIBUTES(WITHOUT DEFAULTS=TRUE)
            
           BEFORE INPUT 
             #隱藏沒有使用到的Button
              CALL cl_str_sepcnt(g_acthidden,",") RETURNING l_j
              IF l_j > 0 THEN
                 FOR l_i=1 TO l_j
                    CALL cl_str_sepsub(g_acthidden,",",l_i,l_i) RETURNING g_act
                    CALL DIALOG.setActionHidden(g_act, 1)
                 END FOR
              END IF

          #資料處理段    
           BEFORE FIELD shb07
              CALL cl_set_comp_visible("page01",TRUE)          #顯示製程頁面   
              CALL cl_set_comp_visible("page02",FALSE)         #隱藏工單頁面
              LET g_page_num = 1
              LET g_shb.shb05 = ''
              LET g_shb.shb06 = ''
              LET g_sfb05 = ''
              LET g_sfb08 = ''
              LET g_sfb09 = ''
              LET g_ima02 = ''

              DISPLAY BY NAME g_shb.shb05,g_shb.shb06
              DISPLAY NULL TO FORMONLY.sfb06             
              DISPLAY NULL TO FORMONLY.sfb06
              DISPLAY NULL TO FORMONLY.sfb05
              DISPLAY NULL TO FORMONLY.sfb08
              DISPLAY NULL TO FORMONLY.sfb09
              DISPLAY NULL TO FORMONLY.ima02

           AFTER FIELD shb07
              IF NOT cl_null(g_shb.shb07) THEN
                 CALL t700_tch2_shb07()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_shb.shb07,g_errno,0)
                    DISPLAY BY NAME g_shb.shb07
                    NEXT FIELD shb07
                #ELSE
                #   CALL t700_tch2_b_fill()                    #查詢/顯示單身資料
                #   CALL t700_b_fresh()
                #   NEXT FIELD shb05
                 END IF
              ELSE
                 DISPLAY NULL TO FORMONLY.eca02
                #NEXT FIELD shb05
              END IF

           BEFORE FIELD shb05
              CALL t700_tch2_b_fill()                          #查詢/顯示單身資料
              CALL t700_b_fresh()
              CALL cl_set_comp_visible("page01",FALSE)         #隱藏製程頁面
              CALL cl_set_comp_visible("page02",TRUE)          #顯示工單頁面    
              LET g_page_num = 2                          

           AFTER FIELD shb05
              IF NOT cl_null(g_shb.shb05) THEN
                 CALL t700_tch2_shb05()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_shb.shb05,g_errno,0) 
                    DISPLAY BY NAME g_shb.shb05
                    NEXT FIELD shb05    
                 END IF   
                #NEXT FIELD shb04                
              ELSE                       
                 DISPLAY NULL TO FORMONLY.sfb06        
                #NEXT FIELD shb04             
              END IF   

           AFTER FIELD shb06
             #IF cl_null(g_shb.shb07) THEN
             #   CALL cl_err('','aec-221',1)
             #   NEXT FIELD shb07
             #END IF
             #IF cl_null(g_shb.shb05) THEN
             #   CALL cl_err('','asf-967',1)
             #   NEXT FIELD shb05
             #END IF
              IF NOT cl_null(g_shb.shb06) THEN
                 CALL t700_tch2_shb06()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_shb.shb06,g_errno,0)
                    DISPLAY BY NAME g_shb.shb06
                    NEXT FIELD shb06
                 END IF
              END IF

           AFTER FIELD shb04
              IF NOT cl_null(g_shb.shb04) THEN
                 CALL t700_tch2_shb04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_shb.shb04,g_errno,0) 
                    DISPLAY BY NAME g_shb.shb04
                    NEXT FIELD shb04
                 END IF 
                 CALL t700_tch2_getbtndata()     #使用者變更,畫面下方製程資料也要更新  
                #NEXT FIELD shb07
              ELSE
                 DISPLAY NULL TO FORMONLY.gen02    
              END IF   

        END INPUT

        DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
           BEFORE ROW
              LET l_ac = ARR_CURR()
              LET g_shb.shb05 = g_sfb[l_ac].sfb01
              LET g_shb.shb06 = g_sfb[l_ac].ecm03 
              LET g_sfb05 = g_sfb[l_ac].sfb05 
              LET g_sfb08 = g_sfb[l_ac].sfb08   
              LET g_sfb09 = g_sfb[l_ac].sfb09
              LET g_ima02 = g_sfb[l_ac].ima02          
              CALL t700_tch2_shb05()     
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_shb.shb05,g_errno,0)
              END IF       
        END DISPLAY

        ON ACTION report_start
           IF cl_null(g_shb.shb07) THEN
              CALL cl_err('','asf-597',1)
              CALL t700_tch2_b_fill()                          #查詢/顯示單身資料
              CALL t700_b_fresh()
              NEXT FIELD shb07
           END IF
           IF cl_null(g_shb.shb05) THEN
              CALL cl_err('','asf-597',1)
              CALL t700_tch2_b_fill()                          #查詢/顯示單身資料
              CALL t700_b_fresh()     
              NEXT FIELD shb05
           END IF
          #IF cl_null(g_shb.shb06) THEN
          #   CALL cl_err('','asf-597',1)
          #   CALL t700_tch2_b_fill()                          #查詢/顯示單身資料
          #   CALL t700_b_fresh()
          #   NEXT FIELD shb06
          #END IF

           LET l_cmd = "asft700_tch3 '",g_shb.shb05,"' '",g_shb.shb07,"' '",
                        g_shb.shb06,"' '",g_shb.shb04,"'"
           CALL cl_cmdrun(l_cmd)

        ON ACTION close
           EXIT DIALOG

        ON IDLE 10
           IF g_page_num = 2 THEN
              CALL t700_tch2_b_fill()
              CALL t700_b_fresh()
           END IF

        #加入預設的ON ACTION
        #&include "flowpic_action.4gl"
         &include "touch_flow_act.4gl"

     END DIALOG
END FUNCTION

FUNCTION t700_tch2_getbtndata()
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_j         LIKE type_file.num5
   DEFINE l_title     DYNAMIC ARRAY OF STRING
   DEFINE l_detail    DYNAMIC ARRAY OF STRING
   #key最多5個，組成字串.每個key以";"分隔
   #kye1=value1;kye2=value2;kye3=value3;kye4=value4;kye5=value5
   DEFINE l_doc_key   DYNAMIC ARRAY OF STRING
   DEFINE l_doc_field DYNAMIC ARRAY OF STRING  #存圖片的欄位
   DEFINE l_gridw     LIKE type_file.num5      #圖片gridWidth
   DEFINE l_gridh     LIKE type_file.num5      #圖片gridHeight
   DEFINE l_cnt       LIKE type_file.num10 
   
   #準備資料      
   LET g_routing[1].title = ""
   LET g_routing[1].v1 = 0
   LET g_routing[1].v2 = 0
   LET g_routing[1].v3 = 0
   LET l_i = 1
   
   #取得此工單共有幾筆製程
   DECLARE t700_tch2_eca CURSOR FOR 
     SELECT * FROM eca_file 
     WHERE ecaacti = 'Y' 
       AND eca04 <> '1'
       AND eca03 = g_gen03
     ORDER BY eca01       
   FOREACH t700_tch2_eca INTO g_eca.*  
                      #"ima01="->g_doc.column1 ;  l_ima01->g_doc.value1
      LET l_doc_key[l_i] = "eca01=",g_eca.eca01   
      LET l_doc_field[l_i] = "ima04"
            
      LET g_routing[l_i].v1 = ""
      LET g_routing[l_i].v2 = ""
      LET g_routing[l_i].v3 = ""
      LET g_routing[l_i].title = ""                         
      LET g_routing[l_i].detail = "工作站: ",g_eca.eca01   
                                 ,"\n說明   : ",g_eca.eca02
                                        
      LET l_title[l_i] = g_routing[l_i].title
      LET l_detail[l_i] = g_routing[l_i].detail
      
      LET g_ecm2[l_i].ecm06 = g_eca.eca01     
  
      LET l_i = l_i + 1    
   END FOREACH
   
   LET l_gridw = 12
   LET l_gridh = 6 
   
  ###############################################################################
  # Description	  : 產生流程圖
  # Date & Author : 2010/06/18 By tsai_yen
  # Parameter     : p_type,p_group,p_col,p_title,p_detail,p_doc_key,p_doc_field,p_gridw,p_gridh
  # Return        : l_acthidden
  ###############################################################################
  #FUNCTION cl_touch_flow(p_type,p_group,p_col,p_title,p_detail,p_doc_key,p_doc_field,p_gridw,p_gridh)
  #   DEFINE p_type          STRING                    #排列方式 ex:"0" / "1"
  #   DEFINE p_group         STRING                    #4fd Group name
  #   DEFINE p_col           LIKE type_file.num5       #一列最多顯示幾個
  #   DEFINE p_title         DYNAMIC ARRAY OF STRING   #標題
  #   DEFINE p_detail        DYNAMIC ARRAY OF STRING   #文字描述
  #   #doc的key=value組成字串.每組以";"分隔
  #   #kye1=value1;kye2=value2;kye3=value3;kye4=value4;kye5=value5
  #   DEFINE p_doc_key       DYNAMIC ARRAY OF STRING   
  #   DEFINE p_doc_field     DYNAMIC ARRAY OF STRING   #存圖片的欄位
  #   DEFINE p_gridw         LIKE type_file.num5       #圖片gridWidth
  #   DEFINE p_gridh         LIKE type_file.num5       #圖片gridHeight
  #   DEFINE l_acthidden     STRING                    #隱藏的按鈕,以","分隔    
   CALL cl_touch_flow("0","flowchar",4,l_title,l_detail,l_doc_key,l_doc_field,l_gridw,l_gridh) 
        RETURNING g_acthidden 
   
END FUNCTION


#產生流程圖按鈕的動作
FUNCTION touch_flow_act(p_act)
   DEFINE p_act     LIKE type_file.num5           #按下第6個按鈕，則p_act = 6
   
   LET g_shb.shb07 = g_ecm2[p_act].ecm06 
   LET g_i = p_act                                #記錄目前是哪個按鈕(array)                     

   CALL t700_tch2_shb07()
  #CALL t700_tch2_b_fill()                        #查詢/顯示單身資料
  #CALL t700_b_fresh()
   DISPLAY BY NAME g_shb.shb07
END FUNCTION


#人員
FUNCTION t700_tch2_shb04()    
   DEFINE l_gen02     LIKE gen_file.gen02,
          l_genacti   LIKE gen_file.genacti

    LET g_errno = ' '
    
    SELECT gen02,gen03,genacti 
      INTO l_gen02,g_gen03,l_genacti
      FROM gen_file 
     WHERE gen01 = g_shb.shb04

    CASE 
      WHEN SQLCA.SQLCODE = 100  
         LET g_errno = 'mfg1312'
         LET l_gen02 = NULL
      WHEN l_genacti='N' 
         LET g_errno = '9028'
      OTHERWISE          
         LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    
    IF cl_null(g_errno) THEN  
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF   
END FUNCTION


#工單編號
FUNCTION t700_tch2_shb05()
  
   DEFINE l_sfb93     LIKE sfb_file.sfb93
   DEFINE l_sfb06     LIKE sfb_file.sfb06
   DEFINE l_cnt       LIKE type_file.num10 
   DEFINE l_ecm52     LIKE ecm_file.ecm52 

    LET g_errno = ' ' 
    
    SELECT sfb93 INTO l_sfb93 
      FROM sfb_file
     WHERE sfb01 = g_shb.shb05
       AND ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR    
            (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2'))     
       AND (sfb28 < '2' OR sfb28 IS NULL)
       AND sfb87!='X'
    IF STATUS THEN                     
       LET g_errno = 'asf-018'           #資料不存在
    ELSE
       IF l_sfb93 <> 'Y' THEN 
          LET g_errno = 'asf-088'        #此張工單不做製程管理!
       ELSE               
          SELECT COUNT(*) INTO l_cnt FROM sfb_file
           WHERE sfb01 = g_shb.shb05 
             AND sfb02='7' 
             AND sfb87!='X'
          IF l_cnt > 0 THEN
             LET g_errno = 'asf-817'                     #此張工單為委外工單!
          ELSE
             SELECT COUNT(*) INTO l_cnt FROM shm_file    #此工單走run card 
              WHERE shm012 = g_shb.shb05
             IF l_cnt > 0 THEN
                LET g_errno = 'asf-927'                  #此工單有RUN CARD 資料,不可在此報工 !!
             END IF
          END IF
       END IF
    END IF   

    IF cl_null(g_errno) THEN
       SELECT COUNT(*) INTO l_cnt FROM ecm_file
        WHERE ecm01 = g_shb.shb05 
          AND ecm06 = g_shb.shb07
       IF l_cnt = 0 THEN 
          LET g_errno = 'aec-222'
       ELSE                 
          IF NOT cl_null(g_shb.shb06) THEN
             SELECT COUNT(*) INTO l_cnt 
               FROM ecm_file
              WHERE ecm01 = g_shb.shb05 
                AND ecm06 = g_shb.shb07  
                AND ecm03 = g_shb.shb06
             IF l_cnt = 0 THEN 
                LET g_errno = 'aec-085'
             ELSE
                SELECT ecm52 INTO l_ecm52 
                  FROM ecm_file
                 WHERE ecm01 = g_shb.shb05
                   AND ecm06 = g_shb.shb07
                   AND ecm03 = g_shb.shb06                
                IF l_ecm52 = 'Y' THEN
                   LET g_errno = 'asf-171'
                ELSE 
                   IF g_sma.sma897='N' THEN
                      SELECT COUNT(*) INTO l_cnt 
                        FROM shb_file
                       WHERE shb05 = g_shb.shb05 
                         AND shb06 = g_shb.shb06
                      IF l_cnt > 0 THEN
                         LET g_errno = 'asf-900'
                      END IF
                   END IF
                END IF
             END IF
          END IF
       END IF
    END IF

    IF cl_null(g_errno) THEN  
       SELECT sfb06 INTO l_sfb06 
         FROM sfb_file
        WHERE sfb01 = g_shb.shb05           
       DISPLAY l_sfb06 TO FORMONLY.sfb06
       DISPLAY g_sfb05 TO FORMONLY.sfb05 
       DISPLAY g_sfb08 TO FORMONLY.sfb08   
       DISPLAY g_sfb09 TO FORMONLY.sfb09
       DISPLAY g_ima02 TO FORMONLY.ima02 
    ELSE
       DISPLAY NULL TO FORMONLY.sfb06 
       DISPLAY NULL TO FORMONLY.sfb05 
       DISPLAY NULL TO FORMONLY.sfb08   
       DISPLAY NULL TO FORMONLY.sfb09
       DISPLAY NULL TO FORMONLY.ima02          
    END IF        
END FUNCTION


#工作站
FUNCTION t700_tch2_shb07()
    DEFINE l_eca02     LIKE eca_file.eca02
    DEFINE l_eca04     LIKE eca_file.eca04
    DEFINE l_cnt       LIKE type_file.num10

    LET g_errno = ' '

    SELECT COUNT(*) INTO l_cnt 
      FROM eca_file
     WHERE eca01 = g_shb.shb07 
       AND ecaacti = 'Y'  
    IF l_cnt = 0 THEN 
       LET g_errno = 'aec-054' 
    ELSE
       SELECT eca04 INTO l_eca04
         FROM eca_file
        WHERE eca01 = g_shb.shb07 
          AND ecaacti = 'Y'
       IF l_eca04 = 1 THEN
          LET g_errno = 'aec-220'
       END IF      
    END IF

    IF cl_null(g_errno) THEN
       SELECT eca02 INTO l_eca02
         FROM eca_file
        WHERE eca01 = g_shb.shb07
       DISPLAY l_eca02 TO FORMONLY.eca02
       CALL t700_tch2_pic(g_shb.shb07)            #顯示工作站圖片
    ELSE
       DISPLAY NULL TO FORMONLY.eca02
    END IF
END FUNCTION


#製程序
FUNCTION t700_tch2_shb06()
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_eca02     LIKE eca_file.eca02

    LET g_errno = ' '

    SELECT COUNT(*) INTO l_cnt FROM ecm_file
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shb.shb06
       AND ecm06 = g_shb.shb07
    IF l_cnt = 0 THEN
       LET g_errno = 'aec-085'
    ELSE
       IF g_ecm2[g_i].ecm52 = 'Y' THEN
          LET g_errno = 'asf-171'
       END IF
       IF cl_null(g_errno) THEN
          IF g_sma.sma897 = 'N' THEN
               SELECT COUNT(*) INTO l_cnt FROM shb_file
                WHERE shb05 = g_shb.shb05
                  AND shb06 = g_shb.shb06
             IF l_cnt > 0 THEN
              #參考設定設為不可分批移轉(sma897='N')，且資料已重複,請重新輸入!
               LET g_errno = 'asf-900'
             END IF
          END IF
       END IF
    END IF
END FUNCTION           


FUNCTION t700_tch2_b_fill() 

   LET g_sql = "SELECT sfb01,sfb05,ima02,sfb08,sfb09,ecm03,sfb15",
               "  FROM sfb_file,ecm_file,ima_file",
               " WHERE sfb01 = ecm01 ", 
               "   AND sfb05 = ima01 ",
               "   AND sfb24 = 'Y'   ",                               #已產生製程追蹤檔
               "   AND sfb02 <> '7'  ",                               #不為委外工單
               "   AND sfb87 = 'Y'   ",                               #[已確認]工單
               "   AND ((sfb04 in (2,3,4,5,6,7,8) AND sfb39='2') ",
               "        OR (sfb04 in (4,5,6,7,8) AND sfb39='1')) ",
               "   AND (sfb28 < '2' OR sfb28 IS NULL) ",           
               "   AND sfb87 != 'X' ",                                #非作廢工單 
               "   AND sfb93 = 'Y'  ",                                #有走製程
               "   AND sfb08 > sfb09",                                #生產數量>完工數量 
               "   AND ecm06 = '",g_shb.shb07,"'",
               "   AND ecm52 <> 'Y' ",                                #
               "   AND sfb01 not in (SELECT shm012 FROM shm_file)"    #非Run Card工單
   PREPARE q700_prepare FROM g_sql
   DECLARE q700_cs SCROLL CURSOR FOR q700_prepare           #SCROLL CURSOR

   CALL g_sfb.clear()
   LET g_rec_b = 0
   LET g_cnt = 1

   FOREACH q700_cs INTO g_sfb[g_cnt].sfb01,g_sfb[g_cnt].sfb05,g_sfb[g_cnt].ima02, 
                        g_sfb[g_cnt].sfb08,g_sfb[g_cnt].sfb09,g_sfb[g_cnt].ecm03, 
                        g_sfb[g_cnt].sfb15
      IF SQLCA.sqlcode THEN
         CALL cl_err('Foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF

      IF g_sfb[g_cnt].sfb08 IS NULL THEN
         LET g_sfb[g_cnt].sfb08 = 0
      END IF

      IF g_sfb[g_cnt].sfb09 IS NULL THEN
         LET g_sfb[g_cnt].sfb09 = 0
      END IF

      SELECT * INTO g_ecm.*
        FROM ecm_file
       WHERE ecm01 = g_sfb[g_cnt].sfb01
         AND ecm03 = g_sfb[g_cnt].ecm03
      IF g_ecm.ecm54='Y' THEN                         #check in 否
         LET g_sfb[g_cnt].wipqty = g_ecm.ecm291                #check in
                                 - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                                 - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                                 - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                                 - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                                 - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
         LET g_sfb[g_cnt].inqty = g_ecm.ecm291
      ELSE
         LET g_sfb[g_cnt].wipqty = g_ecm.ecm301                #良品轉入量
                                 + g_ecm.ecm302                #重工轉入量
                                 + g_ecm.ecm303                #工單轉入
                                 - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                                 - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                                 - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                                 - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                                 - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
         LET g_sfb[g_cnt].inqty = g_ecm.ecm301 + g_ecm.ecm302 + g_ecm.ecm303
      END IF

      LET g_sfb[g_cnt].outqty = (g_ecm.ecm311*g_ecm.ecm59)
                              + (g_ecm.ecm312*g_ecm.ecm59)
                              + (g_ecm.ecm313*g_ecm.ecm59)
                              + (g_ecm.ecm314*g_ecm.ecm59)
                              + (g_ecm.ecm316*g_ecm.ecm59)

      IF (g_sfb[g_cnt].wipqty = 0) OR cl_null(g_sfb[g_cnt].wipqty ) THEN
         CALL g_sfb.deleteElement(g_cnt)
      ELSE     
         LET g_cnt = g_cnt + 1
      END IF

      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH

   CALL g_sfb.deleteElement(g_cnt)   #刪去最後一行空白

  #搬到DIALOG裡
  #DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
  #   BEFORE DISPLAY
  #       EXIT DISPLAY     
  #   #ON IDLE g_idle_seconds
  #   #   CALL cl_on_idle()
  #   #   CONTINUE DISPLAY
  #END DISPLAY   
END FUNCTION  

FUNCTION t700_b_fresh()
   DISPLAY ARRAY g_sfb TO s_sfb.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
          EXIT DISPLAY
   END DISPLAY
END FUNCTION

#顯示工作站圖片
FUNCTION t700_tch2_pic(p_data)
  DEFINE p_data   STRING

    LET g_doc.column1 = "eca01"
    LET g_doc.value1 = p_data
    CALL cl_get_fld_doc("ima04")
END FUNCTION
