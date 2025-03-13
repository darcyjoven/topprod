# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Pattern name...: asft700_tch1.4gl
# Descriptions...: 觸控螢幕製程移轉作業-選擇工單(screen01)
# Date & Author..: 99/06/28 By Lilan 
# Modify.........: No.FUN-B30216 11/03/30
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正

DATABASE ds

#FUN-B30216 

GLOBALS "../../config/top.global"

DEFINE g_argv1      LIKE shb_file.shb05,     #工單單號
       g_argv2      LIKE shb_file.shb07,     #工作站
       g_argv3      LIKE shb_file.shb06,     #製程序
       g_argv4      LIKE shb_file.shb04,     #員工編號
       g_shb        RECORD LIKE shb_file.*,
       g_ecm        RECORD LIKE ecm_file.*,
       g_cond       LIKE ze_file.ze03,       #VARCHAR(10) 
       g_wc,g_wc2   STRING,                
       g_sql        STRING,                      
       g_rec_b      LIKE type_file.num5      #SMALLINT

DEFINE g_ima01      LIKE ima_file.ima01      #主料件編號
DEFINE g_sfb08      LIKE sfb_file.sfb08      #生產量
DEFINE g_sfb09      LIKE sfb_file.sfb09      #完工量
DEFINE p_row,p_col  LIKE type_file.num5      #SMALLINT
DEFINE g_cnt        LIKE type_file.num10     #INTEGER
DEFINE g_msg        LIKE ze_file.ze03,       #VARCHAR(1500)
       l_ac         LIKE type_file.num5      #目前處理的ARRAY CNT        #SMALLINT
DEFINE g_row_count  LIKE type_file.num10     #INTEGER
DEFINE g_curs_index LIKE type_file.num10     #INTEGER
DEFINE g_ecm2       DYNAMIC ARRAY OF RECORD
           ecm03    LIKE ecm_file.ecm03,
           ecm06    LIKE ecm_file.ecm06,
           ecm52    LIKE ecm_file.ecm52           
       END RECORD
DEFINE g_routing    DYNAMIC ARRAY OF RECORD
           title    STRING,
           detail   STRING,
           v1       LIKE type_file.num5,     #在製量
           v2       LIKE type_file.num5,     #轉入量
           v3       LIKE type_file.num5      #轉出量        
       END RECORD                             
DEFINE g_acthidden  STRING                   #隱藏的按鈕,以","分隔
DEFINE g_act        STRING                   #隱藏的按鈕
DEFINE g_i          LIKE type_file.num5      #記錄現在是哪個ecm ARRAY


MAIN
    DEFINE l_time   LIKE type_file.chr8      #VARCHAR(8)

    OPTIONS
       #FORM LINE     FIRST + 2,
       #MESSAGE LINE  LAST,
       #PROMPT LINE   LAST,
        INPUT NO WRAP
    DEFER INTERRUPT

    IF (NOT cl_user()) THEN
      EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
    END IF

    LET g_argv1 = ARG_VAL(1)
    LET g_argv2 = ARG_VAL(2)
    LET g_argv3 = ARG_VAL(3)
    LET g_argv4 = ARG_VAL(4)

   #LET g_argv1 = '511-10070004'
   #LET g_argv2 = '1962_W02'
   #LET g_argv3 = '2'
   #LET g_argv4 = 'tiptop' 

   # CALL cl_used(g_prog,l_time,1) RETURNING l_time          #FUN-B80086   MARK 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time           #FUN-B80086   ADD
 
    INITIALIZE g_ecm.* TO NULL
    INITIALIZE g_shb.* TO NULL

    LET p_row = 1
    LET p_col = 10

    LET g_win_style = "touch-w1"   #yen  #畫面隱藏toolbar....

    OPEN WINDOW asft700_tch1_w AT p_row,p_col WITH FORM "asf/42f/asft700_tch1"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()

    CALL cl_set_act_visible("accept,cancel", FALSE) 
    IF NOT cl_null(g_argv1) THEN
      CALL cl_set_comp_entry("shb04,shb05,shb07",FALSE)
      CALL cl_set_act_visible("report_start",FALSE)
      CALL t700_tch1_menu()    
    ELSE
      CALL cl_set_comp_entry("shb04,shb05,shb07",TRUE)
      CALL cl_set_act_visible("report_start",TRUE)
      CALL t700_tch1_i()
    END IF

    CLOSE WINDOW asft700_tch1_w
   # CALL cl_used(g_prog,l_time,2) RETURNING l_time          #FUN-B80086   MARK
    CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
END MAIN

FUNCTION t700_tch1_menu()
  DEFINE l_i         LIKE type_file.num5
  DEFINE l_j         LIKE type_file.num5
  DEFINE l_title     DYNAMIC ARRAY OF STRING
  DEFINE l_detail    DYNAMIC ARRAY OF STRING
  DEFINE l_doc_key   DYNAMIC ARRAY OF STRING
  DEFINE l_doc_field DYNAMIC ARRAY OF STRING   #存圖片的欄位
  DEFINE l_eca02     LIKE eca_file.eca02
  DEFINE l_gen02     LIKE gen_file.gen02
  DEFINE l_sfb06     LIKE sfb_file.sfb06

    LET g_shb.shb05 = g_argv1
    LET g_shb.shb07 = g_argv2
    LET g_shb.shb06 = g_argv3
    LET g_shb.shb04 = g_argv4

    SELECT gen02 INTO l_gen02
      FROM gen_file
     WHERE gen01 = g_shb.shb04

    SELECT eca02 INTO l_eca02
      FROM eca_file
     WHERE eca01 = g_shb.shb07

    SELECT sfb06 INTO l_sfb06
      FROM sfb_file
     WHERE sfb01 = g_shb.shb05

    DISPLAY BY NAME g_shb.shb05,g_shb.shb07,g_shb.shb06,g_shb.shb04
    DISPLAY l_gen02 TO FORMONLY.gen02
    DISPLAY l_eca02 TO FORMONLY.eca02
    DISPLAY l_sfb06 TO FORMONLY.sfb06


    MENU ""

        BEFORE MENU
           CALL t700_tch1_getbtndata()
           CALL cl_str_sepcnt(g_acthidden,",") RETURNING l_j
           IF l_j > 0 THEN
              FOR l_i=1 TO l_j
                 CALL cl_str_sepsub(g_acthidden,",",l_i,l_i) RETURNING g_act
                 CALL DIALOG.setActionHidden(g_act, 1)
              END FOR
           END IF

        ON ACTION close
         EXIT MENU

       #加入預設的ON ACTION
       #&include "flowpic_action.4gl"
        &include "touch_flow_act.4gl"
    END MENU
END FUNCTION

FUNCTION t700_tch1_i()
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

   LET g_shb.shb04 = g_user          #開啟畫面時，此欄位預設登入者代號
   CALL t700_tch1_shb04()
   
   DISPLAY BY NAME g_shb.shb05,g_shb.shb07,g_shb.shb06,g_shb.shb04
   
   CALL cl_touch_flow("2","flowchar",4,l_title,l_detail,l_doc_key,l_doc_field,0,0) 
        RETURNING g_acthidden 
   
   INPUT BY NAME g_shb.shb05,g_shb.shb07,g_shb.shb06,g_shb.shb04 WITHOUT DEFAULTS

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
      AFTER FIELD shb05
         IF NOT cl_null(g_shb.shb05) THEN
            CALL t700_tch1_shb05()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_shb.shb05,g_errno,0) 
               DISPLAY BY NAME g_shb.shb05
               NEXT FIELD shb05    
            ELSE
               LET g_acthidden = ""
               LET g_act = ""
               
               CALL t700_tch1_getbtndata()                
               CALL cl_str_sepcnt(g_acthidden,",") RETURNING l_j
               IF l_j > 0 THEN
                  FOR l_i=1 TO l_j
                     CALL cl_str_sepsub(g_acthidden,",",l_i,l_i) RETURNING g_act
                     CALL DIALOG.setActionHidden(g_act, 1)
                  END FOR
               END IF

               NEXT FIELD shb07
            END IF   
         ELSE                       
            DISPLAY NULL TO FORMONLY.sfb06                     
         END IF   
                 
      AFTER FIELD shb04
         IF NOT cl_null(g_shb.shb04) THEN
            CALL t700_tch1_shb04()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_shb.shb04,g_errno,0) 
               DISPLAY BY NAME g_shb.shb04
               NEXT FIELD shb04
            ELSE
               NEXT FIELD shb05
            END IF   
         ELSE
            DISPLAY NULL TO FORMONLY.gen02    
         END IF   
         
      AFTER FIELD shb06
         IF cl_null(g_shb.shb05) THEN
            CALL cl_err('','asf-967',1)   
            NEXT FIELD shb05
         END IF
         IF NOT cl_null(g_shb.shb06) THEN
            CALL t700_tch1_shb06()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_shb.shb06,g_errno,0)
               DISPLAY BY NAME g_shb.shb06
               NEXT FIELD shb06
            ELSE
               NEXT FIELD shb04
            END IF
         END IF 
                
      AFTER FIELD shb07
         IF cl_null(g_shb.shb05) THEN
            CALL cl_err('','asf-967',1)
            NEXT FIELD shb05          
         ELSE
            IF NOT cl_null(g_shb.shb07) THEN
               CALL t700_tch1_shb07()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_shb.shb07,g_errno,0)
                  DISPLAY BY NAME g_shb.shb07
                  NEXT FIELD shb07
               ELSE
                  IF cl_null(g_shb.shb06) THEN
                     NEXT FIELD shb06
                  ELSE
                     NEXT FIELD shb04
                  END IF
               END IF
            ELSE
               DISPLAY NULL TO FORMONLY.eca02
               NEXT FIELD shb06
            END IF
         END IF  
 
     #每隔?秒重整畫面(製程流程)資訊
      ON IDLE 10    
         LET g_acthidden = ""
         LET g_act = ""

         CALL t700_tch1_getbtndata()
         CALL cl_str_sepcnt(g_acthidden,",") RETURNING l_j
         IF l_j > 0 THEN
            FOR l_i=1 TO l_j
                CALL cl_str_sepsub(g_acthidden,",",l_i,l_i) RETURNING g_act
                CALL DIALOG.setActionHidden(g_act, 1)
            END FOR
         END IF         

                 
      ON ACTION report_start
         IF cl_null(g_shb.shb07) THEN
            CALL cl_err('','asf-597',1)
            NEXT FIELD shb07
         END IF
         IF cl_null(g_shb.shb06) THEN
            CALL cl_err('','asf-597',1)
            NEXT FIELD shb06
         END IF

         LET l_cmd = "asft700_tch3 '",g_shb.shb05,"' '",g_shb.shb07,"' '",g_shb.shb06,"' '",
                     g_shb.shb04,"'"
         CALL cl_cmdrun(l_cmd)

      ON ACTION close
         EXIT INPUT

      #加入預設的ON ACTION
      #&include "flowpic_action.4gl"
      &include "touch_flow_act.4gl"
   END INPUT

END FUNCTION

FUNCTION t700_tch1_getbtndata()
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
   DEFINE l_ima01     STRING                   #LIKE ima_file.ima01      #主料件編號
   DEFINE l_sfb08     STRING                   #LIKE sfb_file.sfb08      #生產量
   DEFINE l_sfb09     STRING                   #LIKE sfb_file.sfb09      #完工量
   DEFINE l_ima02     LIKE ima_file.ima02      
   DEFINE l_ima021    LIKE ima_file.ima021
   DEFINE l_ima25     LIKE ima_file.ima25
   DEFINE l_wip_qty   LIKE shy_file.shy08      #在製量
   DEFINE l_inqty     LIKE shy_file.shy08      #轉入量
   DEFINE l_outqty    LIKE shy_file.shy08      #轉出量
   
   #準備資料      
   LET g_routing[1].title = ""
   LET g_routing[1].v1 = 0
   LET g_routing[1].v2 = 0
   LET g_routing[1].v3 = 0
   LET l_i = 1
   
   #取得此工單共有幾筆製程
   DECLARE t700_tch1_ecm CURSOR FOR 
     SELECT * FROM ecm_file 
     WHERE ecm01 = g_shb.shb05 
     ORDER BY ecm03       
   FOREACH t700_tch1_ecm INTO g_ecm.*  
      IF g_ecm.ecm54='Y' THEN   #check in 否
         LET l_wip_qty =  g_ecm.ecm291                #check in
                        - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                        - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                        - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                        - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                        - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
         LET l_inqty = g_ecm.ecm291
      ELSE
         LET l_wip_qty =  g_ecm.ecm301                #良品轉入量
                        + g_ecm.ecm302                #重工轉入量
                        + g_ecm.ecm303                #工單轉入
                        - g_ecm.ecm311*g_ecm.ecm59    #良品轉出
                        - g_ecm.ecm312*g_ecm.ecm59    #重工轉出
                        - g_ecm.ecm313*g_ecm.ecm59    #當站報廢
                        - g_ecm.ecm314*g_ecm.ecm59    #當站下線
                        - g_ecm.ecm316*g_ecm.ecm59    #工單轉出
         LET l_inqty = g_ecm.ecm301 + g_ecm.ecm302 + g_ecm.ecm303               
      END IF
      
      LET l_outqty = (g_ecm.ecm311*g_ecm.ecm59) 
                   + (g_ecm.ecm312*g_ecm.ecm59)
                   + (g_ecm.ecm313*g_ecm.ecm59) 
                   + (g_ecm.ecm314*g_ecm.ecm59)
                   + (g_ecm.ecm316*g_ecm.ecm59)      
           
                      #"ima01="->g_doc.column1 ;  l_ima01->g_doc.value1
      LET l_doc_key[l_i] = "eca01=",g_ecm.ecm06 #,";ima02=",l_ima01,";ima03=",l_ima01   
      LET l_doc_field[l_i] = "ima04"
            
      LET g_routing[l_i].v1 = l_wip_qty
      LET g_routing[l_i].v2 = l_inqty
      LET g_routing[l_i].v3 = l_outqty
      LET g_routing[l_i].title = "工作站: ",g_ecm.ecm06                    #USING "&&&"
                                ,"\n製程序: ",g_ecm.ecm03 USING "<<<<<"
      LET g_routing[l_i].detail = "在製量: ",g_routing[l_i].v1," ",g_ecm.ecm57,      #USING "#####",
                                  "\n轉入量: ",g_routing[l_i].v2," ",g_ecm.ecm57,    #USING "#####",
                                  "\n轉出量: ",g_routing[l_i].v3," ",g_ecm.ecm58     #USING "#####"
                                        
      LET l_title[l_i] = g_routing[l_i].title
      LET l_detail[l_i] = g_routing[l_i].detail
      
      LET g_ecm2[l_i].ecm06 = g_ecm.ecm06          #工作站編號
      LET g_ecm2[l_i].ecm03 = g_ecm.ecm03          #製程序
      LET g_ecm2[l_i].ecm52 = g_ecm.ecm52      

      LET l_i = l_i + 1    
   END FOREACH
   
   SELECT sfb05,sfb08,sfb09 
    #INTO l_ima01,l_sfb08,l_sfb09 
     INTO g_ima01,g_sfb08,g_sfb09
     FROM sfb_file 
    WHERE sfb01 = g_shb.shb05

   SELECT ima02,ima021,ima25
     INTO l_ima02,l_ima021,l_ima25
     FROM ima_file
    WHERE ima01 = g_ima01

   CALL t700_tch1_pic(g_ima01)                     #顯示產品圖片   
 
   LET l_ima01 = "產品編號: ",g_ima01,"\n",
                 "\n品名: ",l_ima02,"\n",
                 "\n規格: ",l_ima021,"\n",
                 "\n生產量: ",g_sfb08," ",l_ima25,"\n",
                 "\n完工量: ",g_sfb09," ",l_ima25
   LET l_sfb08 = "生產量: ",g_sfb08
   LET l_sfb09 = "完工量: ",g_sfb09

   DISPLAY l_ima01 TO FORMONLY.te_ima01

   LET l_gridw = 4
   LET l_gridh = 3 
   
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
   CALL cl_touch_flow("2","flowchar",4,l_title,l_detail,l_doc_key,l_doc_field,l_gridw,l_gridh) 
        RETURNING g_acthidden 
   
END FUNCTION


#產生流程圖按鈕的動作
FUNCTION touch_flow_act(p_act)
   DEFINE p_act     LIKE type_file.num5           #按下第6個按鈕，則p_act = 6
  
  #非外部呼叫,按鈕才有作用 
   IF cl_null(g_argv1) THEN 
      LET g_shb.shb07 = g_ecm2[p_act].ecm06 
      LET g_shb.shb06 = g_ecm2[p_act].ecm03 
      LET g_i = p_act                                #記錄目前是哪個按鈕(array)                     

      DISPLAY BY NAME g_shb.shb06,g_shb.shb07
   END IF
END FUNCTION


#人員
FUNCTION t700_tch1_shb04()    
   DEFINE l_gen02     LIKE gen_file.gen02,
          l_genacti   LIKE gen_file.genacti

    LET g_errno = ' '
    
    SELECT gen02,genacti INTO l_gen02,l_genacti
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
FUNCTION t700_tch1_shb05()
   DEFINE l_sfb93     LIKE sfb_file.sfb93
   DEFINE l_sfb06     LIKE sfb_file.sfb06
   DEFINE l_cnt       LIKE type_file.num10 
   
    LET g_errno = ' ' 

    SELECT sfb93 INTO l_sfb93 
      FROM sfb_file
     WHERE sfb01 = g_shb.shb05
       AND ((sfb04 IN ('4','5','6','7','8') AND sfb39='1') OR    
            (sfb04 IN ('2','3','4','5','6','7','8') AND sfb39='2'))     
       AND (sfb28 < '2' OR sfb28 IS NULL)
       AND sfb87!='X'
    IF STATUS THEN                                 #資料不存在
       LET g_errno = 'asf-018'
      #LET g_shb.shb05 = g_shb_t.shb05
    ELSE
       IF l_sfb93 <> 'Y' THEN 
          LET g_errno = 'asf-088'                  #此張工單不做製程管理!
       ELSE               
          SELECT COUNT(*) INTO l_cnt FROM sfb_file
           WHERE sfb01 = g_shb.shb05 
             AND sfb02='7' 
             AND sfb87!='X'
          IF l_cnt > 0 THEN
             LET g_errno = 'asf-817'                  #此張工單為委外工單!
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
       SELECT sfb06 INTO l_sfb06 
         FROM sfb_file
        WHERE sfb01 = g_shb.shb05           
       DISPLAY l_sfb06 TO FORMONLY.sfb06
    ELSE
       DISPLAY NULL TO FORMONLY.sfb06   
    END IF        
END FUNCTION

#工作站
FUNCTION t700_tch1_shb07()
    DEFINE l_eca02     LIKE eca_file.eca02
    DEFINE l_cnt       LIKE type_file.num10

    LET g_errno = ' '

    SELECT COUNT(*) INTO l_cnt FROM ecm_file
     WHERE ecm01 = g_shb.shb05 
       AND ecm06 = g_shb.shb07
    IF l_cnt = 0 THEN 
       LET g_errno = 'aec-222'      
    ELSE
      IF NOT cl_null(g_shb.shb06) THEN
         SELECT COUNT(*) INTO l_cnt FROM ecm_file
          WHERE ecm01 = g_shb.shb05 
            AND ecm06 = g_shb.shb07  
            AND ecm03 = g_shb.shb06
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
      END IF
    END IF

    IF cl_null(g_errno) THEN
       SELECT eca02 INTO l_eca02
         FROM eca_file
        WHERE eca01 = g_shb.shb07
       DISPLAY l_eca02 TO FORMONLY.eca02
    ELSE
       DISPLAY NULL TO FORMONLY.eca02
    END IF
END FUNCTION

#製程序
FUNCTION t700_tch1_shb06()
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_eca02     LIKE eca_file.eca02

    LET g_errno = ' '

    SELECT COUNT(*) INTO l_cnt FROM ecm_file
     WHERE ecm01 = g_shb.shb05
       AND ecm03 = g_shb.shb06
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

   #依據輸入的工單編號&製程序,重新帶出工作站的欄位值
    IF cl_null(g_errno) THEN
       SELECT ecm06 INTO g_shb.shb07
         FROM ecm_file
        WHERE ecm01 = g_shb.shb05
          AND ecm03 = g_shb.shb06

       SELECT eca02 INTO l_eca02
         FROM eca_file
        WHERE eca01 = g_shb.shb07

       DISPLAY BY NAME g_shb.shb07 
       DISPLAY l_eca02 TO FORMONLY.eca02
    END IF
END FUNCTION
              
#顯示產品圖片
FUNCTION t700_tch1_pic(p_data)
  DEFINE p_data   STRING
 
    LET g_doc.column1 = "ima01"
    LET g_doc.value1 = p_data 
    CALL cl_get_fld_doc("ima04")
END FUNCTION


