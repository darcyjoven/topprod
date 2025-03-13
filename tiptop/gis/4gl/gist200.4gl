# Prog. Version..: '5.30.07-13.05.16(00000)'     #
#
# Pattern name...: gist200.4gl
# Descriptions...: 金税组件接口功能调用
# Date & Author..: #No.FUN-A70006 大陆专用金税开票系统
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-D10136 13/01/22 By zhangweib 開局發票之後,回寫發票號碼、發票代碼至axmt670(omf01,omf02)
# Modify.........: No:FUN-D50034 13/05/13 By zhangweib 開立發票數據來源改取isg_file/ish_file

DATABASE ds

GLOBALS "../../config/top.global"  #No.FUN-A70006

DEFINE tm      RECORD
                  wc      LIKE type_file.chr1000,
                  b       LIKE type_file.chr1,
                  d       LIKE type_file.chr1,
                  type    LIKE type_file.chr1   #No.FUN-D10136   Add
                 END RECORD
#No.FUN-D10136 ---start--- Add
DEFINE  g_infotypecode   LIKE type_file.chr100
DEFINE  g_infonumber     LIKE type_file.chr100
DEFINE  g_goodslistflag  STRING
#No.FUN-D10136 ---end  --- Add

MAIN
   DEFINE p_row,p_col     LIKE type_file.num5

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GIS")) THEN
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   LET p_row = 5 LET p_col = 10

   OPEN WINDOW t200_w AT p_row,p_col WITH FORM "gis/42f/gist200"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()
   LET g_action_choice = ""

   CALL t200_menu()

   CLOSE WINDOW t200_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION t200_menu()
   DEFINE l_cmd  LIKE type_file.chr1000

    MENU ""

        #开启金税卡
        ON ACTION open_card
            LET g_action_choice="open_card"
            IF cl_chk_act_auth() THEN
               CALL t200_open_card()
            END IF

        #获取信息
        ON ACTION get
            LET g_action_choice="get"
            IF cl_chk_act_auth() THEN
               CALL t200_get()
            END IF

        #开具发票
        ON ACTION generate_invoice
            LET g_action_choice="generate_invoice"
            IF cl_chk_act_auth() THEN
               CALL t200_generate_invoice()
            END IF

        #关闭金税卡
        ON ACTION close_card
            LET g_action_choice="close_card"
            IF cl_chk_act_auth() THEN
               CALL t200_close_card()
            END IF

        #作废发票
        ON ACTION invalid_invoice
            LET g_action_choice="invalid_invoice"
            IF cl_chk_act_auth() THEN
               CALL t200_invalid_invoice()
            END IF

        #打印发票
        ON ACTION print_invoice
            LET g_action_choice="print_invoice"
            IF cl_chk_act_auth() THEN
               CALL t200_print_invoice()
            END IF

        #退出
        ON ACTION exist_system
            LET g_action_choice="exist_system"
            IF cl_chk_act_auth() THEN
                 CALL t200_exist_system()
            END IF

        ON ACTION help
            CALL cl_show_help()

        ON ACTION exit
            LET g_action_choice = "exit"
            CALL t200_close_card()   #No.FUN-D10136   Add
            EXIT MENU

        ON ACTION controlg
            CALL cl_cmdask()

        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU

        ON ACTION about
           CALL cl_about()

        ON ACTION close
           LET INT_FLAG=FALSE
           CALL t200_close_card()   #No.FUN-D10136   Add
           LET g_action_choice = "exit"
           EXIT MENU

    END MENU
END FUNCTION

#开启金税卡
FUNCTION t200_open_card()
   DEFINE li_result  INTEGER
   DEFINE l_invlimit FLOAT
   DEFINE l_taxcode  STRING
   DEFINE l_taxclock DATE
   DEFINE l_machineno INTEGER
   DEFINE l_isinvempty INTEGER
   DEFINE l_isrepreached INTEGER
   DEFINE l_islockreached INTEGER 
   DEFINE l_att1     STRING

   CALL OpenCard()
     RETURNING li_result
   IF li_result THEN
     LET l_att1 =  "开启金税卡失败！"  
   ELSE
     LET l_att1 =  "开启金税卡成功！" 
   END IF   


   #取得开票限额
   CALL GetInvLimit() 
     RETURNING li_result,l_invlimit 
     IF li_result = 0 THEN
        LET l_att1 = l_att1,"开票限额:",l_invlimit
     END IF
   
   #取得本单位税号
   CALL GetTaxCode()  
     RETURNING li_result,l_taxcode
     IF li_result = 0 THEN
        LET l_att1 = l_att1,"本单位税号:",l_taxcode
     END IF
  
   #取得金税卡时钟
   CALL GetTaxClock()  
     RETURNING li_result,l_taxclock 
     IF li_result = 0 THEN
        LET l_att1 = l_att1,"金税卡时钟:",l_taxclock
     END IF
  
   #取得开票机号码,主开票机为0
   CALL GetMachineNo()
     RETURNING li_result,l_machineno
     IF li_result = 0 THEN
        IF l_machineno = 0 THEN
           LET l_att1 = l_att1,"0.主开票机"
        ELSE
           LET l_att1 = l_att1,"非主开票机"
        END IF   
     END IF

   #取得有票标志,0为金税卡中无可开发票,1为有票
   CALL GetIsInvEmpty()
     RETURNING li_result,l_isinvempty
     IF li_result = 0 THEN
        IF l_isinvempty = 0 THEN
           LET l_att1 = l_att1,"0.无可开发票"
        END IF   
        IF l_isinvempty = 1 THEN
           LET l_att1 = l_att1,"1.有发票"
        END IF   
     END IF
 
   #取得抄税标志,0为未到抄税期,1为已到抄税期
   CALL GetIsRepReached()
     RETURNING li_result,l_isrepreached
     IF li_result = 0 THEN
        IF l_isrepreached = 0 THEN
           LET l_att1 = l_att1,"0.未到抄税期"
        END IF   
        IF l_isrepreached = 1 THEN
           LET l_att1 = l_att1,"1.已到抄税期"
        END IF   
     END IF

   #取得锁死标志,0为未到锁死期,1为已到锁死期
   CALL GetIsLockReached()
     RETURNING li_result,l_islockreached
     IF li_result = 0 THEN
        IF l_islockreached = 0 THEN
           LET l_att1 = l_att1,"0.未到锁死期"
        END IF   
        IF l_islockreached = 1 THEN
           LET l_att1 = l_att1,"1.已到锁死期"
        END IF   
     END IF

   DISPLAY l_att1 TO FORMONLY.att1
END FUNCTION

#获取信息
FUNCTION t200_get()
  DEFINE li_result INTEGER
  DEFINE l_att2    STRING
  DEFINE l_infotypecode STRING
  DEFINE l_infonumber   INTEGER
  DEFINE l_invstock     INTEGER
  DEFINE l_taxclock     DATE
  DEFINE ls_result      STRING

 #No.FUN-D10136 ---start--- Add
   LET tm.type = '0'
   INPUT  tm.type WITHOUT DEFAULTS FROM type
      AFTER FIELD type
         IF cl_null(tm.type) THEN
             NEXT FIELD type
         END IF
   END INPUT

     CALL setInfoKind(tm.type)   
        RETURNING ls_result 
 #No.FUN-D10136 ---end  --- Add

    #查询库存发票
    CALL GetInfo()
      RETURNING li_result
    IF li_result  THEN
       LET l_att2 = "查询库存发票失败"
    ELSE
       LET l_att2 = "查询库存发票成功"
    END IF
 
    #取得开具发票的十位代码
    CALL GetInfoTypeCode()
      RETURNING li_result,l_infotypecode
      IF li_result = 0 THEN
         LET l_att2 = l_att2,"发票的十位代码:",l_infotypecode
      END IF            
      LET g_infotypecode = l_infotypecode       #No.FUN-D10136   Add
      DISPLAY l_infotypecode TO FORMONLY.stat   #No.FUN-D10136   Add

    #取得要开具发票的号码
    CALL GetInfoNumber()
      RETURNING li_result,l_infonumber
      IF li_result = 0 THEN
         LET l_att2 = l_att2,"发票号码:",l_infonumber
      END IF
      LET g_infonumber = l_infonumber        #No.FUN-D10136   Add
      DISPLAY l_infonumber TO FORMONLY.inv   #No.FUN-D10136   Add
    
    #发票剩余份数
    CALL GetInvStock()
      RETURNING li_result,l_invstock
      IF li_result = 0 THEN
         LET l_att2 = l_att2,"发票剩余份数:",l_invstock
      END IF
    
    #金税卡时钟
    CALL GetTaxClock()
      RETURNING li_result,l_taxclock
      IF li_result = 0 THEN
         LET l_att2 = l_att2,"金税卡时钟:",l_taxclock
      END IF

    DISPLAY l_att2 to FORMONLY.att2

END FUNCTION

#开具发票
FUNCTION t200_generate_invoice()
 
   DEFINE p_row,p_col     LIKE type_file.num5
  
   OPEN WINDOW  t200_inv_w AT p_row,p_col
        WITH FORM "gis/42f/gist200_g"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_locale("gist200_g")
   CALL cl_set_comp_visible("b,d",FALSE)     #No.FUN-D10136   Add

   CALL cl_opmsg('z')

   CALL t200_inv()
  
   CLOSE WINDOW t200_inv_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time

END FUNCTION

#关闭金税卡
FUNCTION t200_close_card()
   DEFINE li_result   INTEGER
   DEFINE l_att3      STRING
 
   CALL CloseCard()
     RETURNING li_result
     IF li_result THEN
        LET l_att3 = "关闭金税卡失败！"  
     ELSE
        LET l_att3 = "关闭金税卡成功！"
     END IF

     DISPLAY l_att3 to FORMONLY.att3

END FUNCTION

#作废发票
FUNCTION t200_invalid_invoice()
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE li_result        INTEGER
   DEFINE l_infotypecode   STRING
   DEFINE l_infonumber     STRING
   DEFINE l_result         STRING
   DEFINE l_result2        STRING
   DEFINE l_att5           STRING


      #输入作废发票的号码和代码
      OPEN WINDOW  t200_inv_c AT p_row,p_col
          WITH FORM "gis/42f/gist200_c"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("gist200_c")

      INPUT  l_infotypecode,l_infonumber
        WITHOUT DEFAULTS
        FROM isa02,isa01 
         AFTER FIELD isa02
            IF cl_null(l_infotypecode) THEN
                NEXT FIELD isa02
            END IF        

         AFTER FIELD isa01
            IF cl_null(l_infonumber)  THEN
                NEXT FIELD isa01
            END IF       
      END INPUT 
      CLOSE WINDOW t200_inv_c
      
      #传入作废发票的十位代码
      CALL SetInfoTypeCode(l_infotypecode)
         RETURNING li_result

      #传入作废发票的号码
      CALL SetInfoNumber(l_infonumber)
         RETURNING li_result
      
      #发票作废
      CALL CancelInv()
         RETURNING li_result
      
      IF li_result = 0 THEN
   
         #取得作废发票的十位代码信息
         CALL GetInfoTypeCode()
           RETURNING li_result,l_result

         #取得作废发票的号码
         CALL GetInfoNumber()
           RETURNING li_result,l_result2

      END IF

      LET l_att5 = l_infotypecode CLIPPED,"-",l_infonumber CLIPPED
      
      CASE
          WHEN l_result2 = '6001'
            LET l_att5 = l_att5,"当月发票库未找到该发票"
          WHEN l_result2 = '6002'
            LET l_att5 = l_att5,"该发票已经作废"
          WHEN l_result2 = '6011'
            LET l_att5 = l_att5,"作废成功"
          WHEN l_result2 = '6012'
            LET l_att5 = l_att5,"未作废"
          WHEN l_result2 = '6013'
            LET l_att5 = l_att5,"作废失败"
      END CASE
      
      DISPLAY l_att5 TO FORMONLY.att5

END FUNCTION

#打印发票
FUNCTION t200_print_invoice()
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE  li_result        INTEGER
   DEFINE  l_infotypecode   STRING
   DEFINE  l_infonumber     STRING
   DEFINE  l_goodslistflag  STRING
   DEFINE  l_result         STRING
   DEFINE  l_result2        STRING
   DEFINE  l_result3        INTEGER 
   DEFINE  l_att5           STRING
   DEFINE  hx_infonumber    LIKE type_file.chr100    #No.FUN-D10136   Add
   DEFINE  hx_infotypecode  LIKE type_file.chr100    #No.FUN-D10136   Add
  


      #输入打印发票的号码\代码\销货清单标志
      OPEN WINDOW  t200_inv_o AT p_row,p_col
          WITH FORM "gis/42f/gist200_o"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
      CALL cl_ui_locale("gist200_o")
       
      INPUT  l_infotypecode,l_infonumber,l_goodslistflag
         WITHOUT DEFAULTS
        FROM isa02,isa01,isa00
      
        #No.FUN-D10136 ---start--- Add
         BEFORE INPUT  
           #取得开具发票的十位代码
            CALL GetInfoTypeCode()
               RETURNING li_result,l_infotypecode
              
         
           #取得要开具发票的号码
            CALL GetInfoNumber()
               RETURNING li_result,l_infonumber      

            DISPLAY l_infonumber,l_infotypecode TO isa01,isa02
        #No.FUN-D10136 ---end  --- Add

         AFTER FIELD isa02
            IF cl_null(l_infotypecode) THEN
                NEXT FIELD isa02
            END IF        

         AFTER FIELD isa01
            IF cl_null(l_infonumber)  THEN
                NEXT FIELD isa01
            END IF       
  
         AFTER FIELD isa00
            IF cl_null(l_goodslistflag) 
              OR l_goodslistflag NOT MATCHES '[01]'  THEN
                NEXT FIELD isa00
            END IF  
      END INPUT
      CLOSE WINDOW t200_inv_o

      #传入打印发票的十位代码
      CALL SetInfoTypeCode(l_infotypecode)
         RETURNING li_result

      #传入打印发票的号码
      CALL SetInfoNumber(l_infonumber)
         RETURNING li_result

      #传入打印发票的销货清单标志
      CALL SetGoodsListFlag(l_goodslistflag)
         RETURNING li_result
     
      #发票打印
      CALL PrintInv()
         RETURNING li_result

      IF li_result = 0 THEN     
         #取得打印发票的十位代码信息
          CALL GetInfoTypeCode()
            RETURNING li_result,l_result

         #取得打印发票的号码
          CALL GetInfoNumber()
            RETURNING li_result,l_result2

         #取得打印发票的销货清单标志
          CALL GetGoodsListFlag()
            RETURNING li_result,l_result3

      END IF
     
        LET l_att5 = l_infotypecode CLIPPED,"-",l_infonumber CLIPPED
      
      CASE
          WHEN l_result2 = '5001'
            LET l_att5 = l_att5,"未找到该发票和清单"
          WHEN l_result2 = '5011'
            LET l_att5 = l_att5,"打印成功"
           #No.FUN-D30136 ---start--- Add
            LET hx_infotypecode = l_infotypecode
            UPDATE isa_file SET isa07 = '2'
             WHERE isa01 = hx_infonumber
               AND isa02 = hx_infotypecode
               AND isa07 = '1'
            IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("upd","isa_file",'','',STATUS,"","upd isa07",1)
            END IF
           #No.FUN-D30136 ---end  --- Add
          WHEN l_result2 = '5012'
            LET l_att5 = l_att5,"未打印"
          WHEN l_result2 = '5013'
            LET l_att5 = l_att5,"打印失败"
      END CASE


   DISPLAY l_att5 TO FORMONLY.att5

END FUNCTION

#退出
FUNCTION t200_exist_system()
   CALL t200_close_card()     #No.FUN-D10136    Add
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
   EXIT PROGRAM
END FUNCTION

FUNCTION t200_inv()
#No.FUN-D10136 ---start--- Add
   DEFINE l_isa062 LIKE isa_file.isa062
   DEFINE l_isa00  LIKE isa_file.isa00
   DEFINE l_isa01  LIKE isa_file.isa01
   DEFINE l_isa05 LIKE isa_file.isa05
   DEFINE l_isa04 LIKE isa_file.isa04
#No.FUN-D10136 ---end  --- Add

  WHILE TRUE
    CLEAR FORM
#   CONSTRUCT BY NAME tm.wc ON isa04,isa05,isa062,isa00  #No.FUN-D10136   Mark 
    CONSTRUCT BY NAME tm.wc ON isa04,isa05,isa00         #No.FUN-D10136   Add
       BEFORE CONSTRUCT
         CALL cl_qbe_init()
        #No.FUN-D10136 ---start--- Add
         CASE tm.type
            WHEN 0
               LET l_isa062='A'
            WHEN 1
               LET l_isa062='C'
            WHEN 2
               LET l_isa062='B'
         END CASE
         DISPLAY l_isa062 TO isa062

       AFTER FIELD isa04   
         LET l_isa04 = GET_FLDBUF(isa04)
         IF NOT cl_null(l_isa04) THEN 
            SELECT isa05,isa00,isa01 INTO l_isa05,l_isa00,l_isa01 
              FROM isa_file 
       	     WHERE isa04 = l_isa04
       	    DISPLAY l_isa00 TO isa00
            DISPLAY l_isa05 TO isa05 	       	  
            IF NOT cl_null(l_isa01) THEN
               CALL cl_err('已经开过票了','!',1)
               NEXT FIELD isa04
            END IF
         END IF 

      ON ACTION CONTROLP
         IF INFIELD(isa04) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ise04"
            LET g_qryparam.default1 = l_isa04
            CALL cl_create_qry() RETURNING l_isa04
            DISPLAY l_isa04 TO isa04
            NEXT FIELD isa04  #add by tangjian 
         END IF
         	
         IF INFIELD(isa05) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ise05"
            LET g_qryparam.default1 = l_isa05
            CALL cl_create_qry() RETURNING l_isa05
            DISPLAY l_isa05 TO isa05
            NEXT FIELD isa05  #add by tangjian 
         END IF
         IF INFIELD(isa00) THEN
            CALL cl_init_qry_var()
            LET g_qryparam.form = "q_ise00"
            LET g_qryparam.default1 = l_isa00
            CALL cl_create_qry() RETURNING l_isa00
            DISPLAY l_isa00 TO isa00
            NEXT FIELD isa00  #add by tangjian 
         END IF
        #No.FUN-D10136 ---end  --- Add
    
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

   END CONSTRUCT

   IF INT_FLAG THEN
      LET INT_FLAG = 0 EXIT WHILE
   END IF

   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0)  CONTINUE WHILE
   END IF

   LET tm.b = 'N'
   LET tm.d = 'N' 

#  INPUT BY NAME tm.b,tm.d WITHOUT DEFAULTS
#     AFTER FIELD b
#       IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN
#          NEXT FIELD b
#       END IF        

#     AFTER FIELD d
#       IF cl_null(tm.d) OR tm.d NOT MATCHES '[YN]' THEN
#          NEXT FIELD d
#       END IF       

#     
#     ON ACTION CONTROLR
#        CALL cl_show_req_fields()
#    
#     ON ACTION CONTROLG
#        CALL cl_cmdask()
#    
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE INPUT
#    
#     ON ACTION about
#        CALL cl_about()
#  
#     ON ACTION help   
#        CALL cl_show_help()
#    
#     ON ACTION qbe_save
#        CALL cl_qbe_save()
#   
#   END INPUT
#
    IF INT_FLAG THEN
       LET INT_FLAG = 0 EXIT WHILE
    END IF
    IF NOT cl_sure(0,0) THEN
          RETURN
    END IF
    CALL cl_wait()
    CALL t200_inv_g()
    ERROR ''
    IF INT_FLAG THEN
       LET INT_FLAG = 0 EXIT WHILE
    END IF
  END WHILE
END FUNCTION

#No.FUN-D50034 ---Mark--- Start
#FUNCTION t200_inv_g()
#  DEFINE l_sql     LIKE type_file.chr1000
#  DEFINE l_name    LIKE type_file.chr20
#  DEFINE l_cnt         LIKE type_file.num5
#  DEFINE l_str         LIKE type_file.chr1000
#  DEFINE l_za05        LIKE type_file.chr1000
#  DEFINE li_result     INTEGER
#  DEFINE ls_result     STRING
#  DEFINE lf_result     FLOAT
#  DEFINE l_zo12        LIKE zo_file.zo12
#  DEFINE l_zo05        LIKE zo_file.zo05
#  DEFINE l_zo041       LIKE zo_file.zo041
#  DEFINE l_nma03       LIKE nma_file.nma03
#  DEFINE l_nma04       LIKE nma_file.nma04
#  DEFINE l_zo13        LIKE zo_file.zo13
#  DEFINE l_bankname    LIKE isa_file.isa054
#  DEFINE l_address     LIKE isa_file.isa053
#  DEFINE sr            RECORD
#                       isa   RECORD LIKE isa_file.*
#                       END RECORD
#  DEFINE l_isa01       LIKE isa_file.isa01   #No.FUN-D10136   Add
#  DEFINE l_isa02       LIKE isa_file.isa02   #No.FUN-D10136   Add
#  DEFINE l_isa04       LIKE isa_file.isa04   #No.FUN-D10136   Add
#  DEFINE l_isa062      LIKE isa_file.isa062  #No.FUN-D10136   Add 
#  DEFINE  hx_infotypecode  LIKE type_file.chr100   #No.FUN-D10136   Add
#  DEFINE  hx_infonumber    LIKE type_file.chr100   #No.FUN-D10136   Add
#  DEFINE l_gen02 LIKE gen_file.gen02         #No.FUN-D10136   Add

# #No.FUN-D10136 ---start--- Add
#  CASE tm.type
#     WHEN 0
#        LET l_isa062='A'
#     WHEN 1
#        LET l_isa062='C'
#     WHEN 2
#        LET l_isa062='B'
#  END CASE
# #No.FUN-D10136 ---end  --- Add

#  SELECT zo05,zo12,zo041,zo13 INTO l_zo05,l_zo12,l_zo041,l_zo13
#    FROM zo_file
#   WHERE zo01 = '2'
#  LET l_address = l_zo041 CLIPPED,l_zo05 CLIPPED
#  SELECT nma03,nma04 INTO l_nma03,l_nma04
#    FROM nma_file
#   WHERE nma01 = l_zo13
#  LET l_bankname = l_nma03 CLIPPED,l_nma04 CLIPPED
#  LET g_success='Y'     #No.FUN-D10136   Add 
#  BEGIN WORK            #No.FUN-D10136   Add
#  LET l_sql = "SELECT * FROM isa_file ",
#              "  WHERE isa07 <>'V' ",
#              "   AND isa062 = '",l_isa062,"'",    #No.FUN-D10136   Add
#              "   AND ",tm.wc CLIPPED,
#              " ORDER BY isa04 "
#  PREPARE t200_inv_g_pre1 FROM l_sql
#  IF STATUS THEN CALL cl_err('t200_inv_g_pre1',STATUS,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#     EXIT PROGRAM
#  END IF
#  DECLARE t200_inv_g_curs1 CURSOR FOR t200_inv_g_pre1
#  FOREACH t200_inv_g_curs1 INTO sr.*
#     IF STATUS THEN
#        CALL cl_err('t200_inv_g_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
#     END IF
#    #No.FUN-D10136 ---start--- Add
#     #传入发票明细信息前用此函数初始化发票明细信息各项属性
#      CALL  InvInfoInit()    
#           RETURNING li_result
#    #No.FUN-D10136 ---end  --- Add
#     #购方名称(客户全称)
#      CALL setInfoClientName(sr.isa.isa051)
#           RETURNING ls_result
#  
#     #购方税号(客户税号)
#      CALL  setInfoClientTaxCode(sr.isa.isa052)            
#           RETURNING ls_result 
#   
#     #购方开户银行及帐号
#      CALL  setInfoClientBankAccount(sr.isa.isa054)
#           RETURNING ls_result
# 
#     #购方地址电话
#      CALL  setInfoClientAddressPhone(sr.isa.isa053)
#           RETURNING ls_result
#
#     #销方开户行及账号
#      CALL  setInfoSellerBankAccount(l_bankname)      
#           RETURNING ls_result
#    
#     #销方地址电话
#      CALL  setInfoSellerAddressPhone(l_address)    
#           RETURNING ls_result

#     #税率
#      CALL  setInfoTaxRate(sr.isa.isa061)  
#           RETURNING ls_result
#
#     #备注，按税务总局规定，开具负数发票必须在备注首行中注明"对应正数发票代码XXXXXXXXXX 号码YYYYYYYY"字样，其中"X"为发票左上角十位代码数字，"Y"为发票号码右上角八位号码数字。
#      CALL  setInfoNotes(sr.isa.isa10)
#           RETURNING ls_result

#     #开票人名称
#      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.isa.isaud02   #No.FUN-D10136   Add
#      CALL  setInfoInvoicer(l_zo12) 
#           RETURNING ls_result

#     #复核人，可为空
#      CALL  setInfoChecker('')
#           RETURNING ls_result

#     #收款人，可为空
#      CALL  setInfoCashier('')    
#           RETURNING ls_result

#     #如不为空，则开具销货清单，此为发票上商品名称栏的清单信息，应为"(详见销货清单)"字样
#      CALL  setInfoListName('')
#           RETURNING ls_result

#     #如有必要用此函数清除明细表全部行
#      CALL  ClearInvList()   
#           RETURNING li_result
#
#     #传入发票明细信息前用此函数初始化发票明细信息各项属性
#      CALL  InvInfoInit()   
#           RETURNING li_result

#     #传入发票明细信息
#      CALL t200_inv_g_detail(sr.isa.isa04)  

#     #传入开票数据，将开票数据记入防伪税控开票数据库，并在金税卡中开具此发票
#      CALL  Invoice()  
#           RETURNING li_result
#     #No.FUN-D10136 ---start--- Add
#      LET hx_infotypecode  =   g_infotypecode
#      LET hx_infonumber =   g_infonumber
#      IF li_result = 0 THEN
#      	  LET l_str = "账单编号:",sr.isa.isa04,"开票成功"
#      	  CALL cl_err(l_str,'!',1)
#         IF tm.b = 'Y' THEN
#           LET l_sql = "UPDATE isa_file SET isa07 = '1' ",
#                       " WHERE isa07 = '0' ",
#                       "   AND isa04 = '",sr.isa.isa04,"' "
#           PREPARE t200_inv_g_pre2 FROM l_sql
#           IF STATUS THEN
#              CALL cl_err('t200_inv_g_pre2',STATUS,1) 
#              LET g_success='N'
#           END IF
#           EXECUTE t200_inv_g_pre2
#           IF STATUS THEN
#              CALL cl_err('execute',STATUS,1) 
#              LET g_success='N'
#           END IF
#           UPDATE isa_file SET isa01 = hx_infonumber,isa02 = hx_infotypecode
#            WHERE isa04 = sr.isa.isa04
#              AND isa01 = ' ' 
#              AND isa02 = ' '
#           IF STATUS THEN
#              CALL cl_err('upd isa',STATUS,1) 
#              LET g_success='N'
#           END IF     
#           UPDATE isb_file SET isb01 = hx_infonumber,isb11 = hx_infotypecode
#            WHERE isb02 = sr.isa.isa04
#              AND isb01 = ' ' 
#              AND isb11 = ' '
#           IF STATUS THEN
#              CALL cl_err('upd isa',STATUS,1) 
#              LET g_success='N'
#           END IF            	       	
#           UPDATE omf_file SET omf01 = hx_infonumber,omf02 = hx_infotypecode
#            WHERE omf00 = sr.isa.isa04
#              AND omf01 = ' ' 
#              AND omf02 = ' '
#           IF STATUS THEN
#              CALL cl_err('upd isa',STATUS,1) 
#              LET g_success='N'
#           END IF            	
#         END IF       	        	         	  
#      ELSE 
#      	  LET l_str = "账单编号:",sr.isa.isa04,"不存在"
#      	  CALL cl_err(l_str,'!',1)       	      	
#      END IF 
#     #No.FUN-D10136 ---end  --- Add

#  END FOREACH

#  IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF    #No.FUN-D10136   Add

# #No.FUN-D10136 ---start--- Add
# #IF tm.b = 'Y' THEN
# #   BEGIN WORK
# #   LET g_success='Y'
# #   LET l_sql = "UPDATE isa_file SET isa07 = '1' ",
# #               " WHERE isa07 = '0' ",
# #               "   AND ",tm.wc CLIPPED
# #   PREPARE t200_inv_g_pre2 FROM l_sql
# #   IF STATUS THEN
# #      CALL cl_err('t200_inv_g_pre2',STATUS,1) LET g_success='N'
# #   END IF
# #   EXECUTE t200_inv_g_pre2
# #   IF STATUS THEN
# #      CALL cl_err('execute',STATUS,1) LET g_success='N'
# #   END IF
# #   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
# #END IF
# #No.FUN-D10136 ---start--- Add
#END FUNCTION

#FUNCTION t200_inv_g_detail(p_isa04)
#  DEFINE l_sql2        LIKE type_file.chr1000
#  DEFINE p_isa04       LIKE isa_file.isa04
#  DEFINE l_price       LIKE isb_file.isb09
#  DEFINE l_name2       LIKE type_file.chr20
#  DEFINE l_cnt2        LIKE type_file.num5
#  DEFINE l_str2        LIKE type_file.chr1000
#  DEFINE l_za052       LIKE type_file.chr1000
#  DEFINE li_result     INTEGER
#  DEFINE ls_result     STRING
#  DEFINE lf_result     FLOAT
#  DEFINE sr2           RECORD
#                       isb   RECORD LIKE isb_file.*
#                       END RECORD
#  
#  DECLARE t200_inv_g_detail_curs2 CURSOR FOR
#    SELECT * FROM isb_file
#      WHERE isb02 = p_isa04
#       ORDER BY isb02
#  IF STATUS THEN CALL cl_err('t200_inv_g_detail_curs2',STATUS,1)
#     CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#     EXIT PROGRAM
#  END IF
#  FOREACH t200_inv_g_detail_curs2 INTO sr2.*
#     IF STATUS THEN
#        CALL cl_err('t200_inv_g_detail_curs2',STATUS,1) LET g_success = 'N' EXIT FOREACH
#     END IF
#     #LET l_price = sr2.isb.isb09/sr2.isb.isb08     #No.FUN-D10136   Mark
#      LET l_price = sr2.isb.isb09t/sr2.isb.isb08    #No.FUN-D10136   Add
#      #---------发票明细信息----------------------------------------------------------------------------------------------
#      CALL  InvListInit()
#          RETURNING ls_result
#  
#     #销售商品或劳务名称
#      CALL  setListGoodsName(sr2.isb.isb05)
#          RETURNING li_result
#     
#     #税目,4位数字,商品所属类别
#      CALL  setListTaxItem(sr2.isb.isb10)  
#          RETURNING li_result
#     
#     #规格型号
#      CALL  setListStandard(sr2.isb.isb06)
#          RETURNING li_result
#  
#     #计量单位
#      CALL  setListUnit(sr2.isb.isb07)
#          RETURNING li_result
# 
#     #数量
#      CALL  setListNumber(sr2.isb.isb08)   
#          RETURNING lf_result
# 
#     #单价
#      CALL  setListPrice(l_price) 
#          RETURNING lf_result

#     #金额，可不传(为0)，由接口软件计算，如传入则应符合计算关系
#      CALL  setListAmount(0)  
#          RETURNING lf_result
# 
#     #含税价标志，0位不含税价，1为含税价
#     #CALL  setListPriceKind(0)   #No.FUN-D10136   Mark 
#      CALL  setListPriceKind(0)   #No.FUN-D10136   Add
#          RETURNING lf_result
#   
#     #税额，可不传(为0)，由接口软件计算，如传入则应符合计算关系
#      CALL  setListTaxAmount(0)
#          RETURNING lf_result
#   
#     #将本行加入明细表
#      CALL  AddInvList() 
#          RETURNING li_result
#  END FOREACH

#END FUNCTION
#No.FUN-D50034 ---Mark--- End

#No.FUN-D50034 ---Add--- Start
FUNCTION t200_inv_g()
   DEFINE l_sql         LIKE type_file.chr1000
   DEFINE l_name        LIKE type_file.chr20
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_str         LIKE type_file.chr1000
   DEFINE l_za05        LIKE type_file.chr1000
   DEFINE li_result     INTEGER
   DEFINE ls_result     STRING
   DEFINE lf_result     FLOAT
   DEFINE l_zo12        LIKE zo_file.zo12
   DEFINE l_zo05        LIKE zo_file.zo05
   DEFINE l_zo041       LIKE zo_file.zo041
   DEFINE l_nma03       LIKE nma_file.nma03
   DEFINE l_nma04       LIKE nma_file.nma04
   DEFINE l_zo13        LIKE zo_file.zo13
   DEFINE l_bankname    LIKE isg_file.isg06
   DEFINE l_address     LIKE isg_file.isg05
   DEFINE sr            RECORD
                        isa   RECORD LIKE isa_file.*,
                        isg   RECORD LIKE isg_file.*
                        END RECORD
   DEFINE l_isa01       LIKE isa_file.isa01   
   DEFINE l_isa02       LIKE isa_file.isa02   
   DEFINE l_isg01       LIKE isg_file.isg01   
   DEFINE l_isa062      LIKE isa_file.isa062    
   DEFINE l_gen02       LIKE gen_file.gen02         
   DEFINE  hx_infotypecode  LIKE type_file.chr100   
   DEFINE  hx_infonumber    LIKE type_file.chr100 

   CASE tm.type
      WHEN 0
         LET l_isa062='A'
      WHEN 1
         LET l_isa062='C'
      WHEN 2
         LET l_isa062='B'
   END CASE

   SELECT zo05,zo12,zo041,zo13 INTO l_zo05,l_zo12,l_zo041,l_zo13
     FROM zo_file
    WHERE zo01 = '2'
   LET l_address = l_zo041 CLIPPED,l_zo05 CLIPPED
   SELECT nma03,nma04 INTO l_nma03,l_nma04
     FROM nma_file
    WHERE nma01 = l_zo13
   LET l_bankname = l_nma03 CLIPPED,l_nma04 CLIPPED
   LET g_success='Y'    
   BEGIN WORK           
   LET l_sql = "SELECT * FROM isa_file,isg_file ",
               " WHERE isa07 <>'V' ",
               "   AND isa04 = isg01",
               "   AND isa062 = '",l_isa062,"'",   
               "   AND ",tm.wc CLIPPED,
               " ORDER BY isg01 "
   PREPARE t200_inv_g_pre1 FROM l_sql
   IF STATUS THEN CALL cl_err('t200_inv_g_pre1',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time 
      EXIT PROGRAM
   END IF
   DECLARE t200_inv_g_curs1 CURSOR FOR t200_inv_g_pre1
   FOREACH t200_inv_g_curs1 INTO sr.*
      IF STATUS THEN
         CALL cl_err('t200_inv_g_curs1',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      #传入发票明细信息前用此函数初始化发票明细信息各项属性
       CALL  InvInfoInit()    
            RETURNING li_result
      #购方名称(客户全称)
       CALL setInfoClientName(sr.isg.isg03)
            RETURNING ls_result
   
      #购方税号(客户税号)
       CALL  setInfoClientTaxCode(sr.isg.isg04)            
            RETURNING ls_result 
    
      #购方开户银行及帐号
       CALL  setInfoClientBankAccount(sr.isg.isg06)
            RETURNING ls_result
  
      #购方地址电话
       CALL  setInfoClientAddressPhone(sr.isg.isg05)
            RETURNING ls_result
 
      #销方开户行及账号
       CALL  setInfoSellerBankAccount(l_bankname)      
            RETURNING ls_result
     
      #销方地址电话
       CALL  setInfoSellerAddressPhone(l_address)    
            RETURNING ls_result

      #税率
       CALL  setInfoTaxRate(sr.isa.isa061)  
            RETURNING ls_result
 
      #备注，按税务总局规定，开具负数发票必须在备注首行中注明"对应正数发票代码XXXXXXXXXX 号码YYYYYYYY"字样，其中"X"为发票左上角十位代码数字，"Y"为发票号码右上角八位号码数字。
       CALL  setInfoNotes(sr.isg.isg07)
            RETURNING ls_result

      #开票人名称
       SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = sr.isa.isaud02
       CALL  setInfoInvoicer(l_zo12) 
            RETURNING ls_result

      #复核人，可为空
       CALL  setInfoChecker('')
            RETURNING ls_result

      #收款人，可为空
       CALL  setInfoCashier('')    
            RETURNING ls_result

      #如不为空，则开具销货清单，此为发票上商品名称栏的清单信息，应为"(详见销货清单)"字样
       CALL  setInfoListName('')
            RETURNING ls_result

      #如有必要用此函数清除明细表全部行
       CALL  ClearInvList()   
            RETURNING li_result
 
      #传入发票明细信息前用此函数初始化发票明细信息各项属性
#      CALL  InvInfoInit()   
#           RETURNING li_result

      #传入发票明细信息
       CALL t200_inv_g_detail(sr.isg.isg01)  

      #传入开票数据，将开票数据记入防伪税控开票数据库，并在金税卡中开具此发票
       CALL  Invoice()  
            RETURNING li_result
       LET hx_infotypecode  =   g_infotypecode
       LET hx_infonumber =   g_infonumber
       IF li_result = 0 THEN
       	  LET l_str = "账单编号:",sr.isg.isg01,"开票成功"
       	  CALL cl_err(l_str,'!',1)
          IF tm.b = 'Y' THEN
            LET l_sql = "UPDATE isa_file SET isa07 = '1' ",
                        " WHERE isa07 = '0' ",
                        "   AND isa04 = '",sr.isg.isg01,"' "
            PREPARE t200_inv_g_pre2 FROM l_sql
            IF STATUS THEN
               CALL cl_err('t200_inv_g_pre2',STATUS,1) 
               LET g_success='N'
            END IF
            EXECUTE t200_inv_g_pre2
            IF STATUS THEN
               CALL cl_err('execute',STATUS,1) 
               LET g_success='N'
            END IF
            UPDATE isa_file SET isa01 = hx_infonumber,isa02 = hx_infotypecode
             WHERE isg01 = sr.isg.isg01
               AND isa01 = ' ' 
               AND isa02 = ' '
            IF STATUS THEN
               CALL cl_err('upd isa',STATUS,1) 
               LET g_success='N'
            END IF     
            UPDATE ish_file SET isb01 = hx_infonumber,isb11 = hx_infotypecode
             WHERE isb02 = sr.isg.isg01
               AND isb01 = ' ' 
               AND isb11 = ' '
            IF STATUS THEN
               CALL cl_err('upd isa',STATUS,1) 
               LET g_success='N'
            END IF            	       	
            UPDATE omf_file SET omf01 = hx_infonumber,omf02 = hx_infotypecode
             WHERE omf00 = sr.isg.isg01
               AND omf01 = ' ' 
               AND omf02 = ' '
            IF STATUS THEN
               CALL cl_err('upd isa',STATUS,1) 
               LET g_success='N'
            END IF            	
         END IF       	        	         	  
      ELSE 
         LET l_str = "账单编号:",sr.isg.isg01,"不存在"
         CALL cl_err(l_str,'!',1)       	      	
      END IF

   END FOREACH

   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF 
END FUNCTION

FUNCTION t200_inv_g_detail(p_isg01)
   DEFINE l_sql2        LIKE type_file.chr1000
   DEFINE p_isg01       LIKE isg_file.isg01
   DEFINE l_price       LIKE ish_file.ish08
   DEFINE l_name2       LIKE type_file.chr20
   DEFINE l_cnt2        LIKE type_file.num5
   DEFINE l_str2        LIKE type_file.chr1000
   DEFINE l_za052       LIKE type_file.chr1000
   DEFINE li_result     INTEGER
   DEFINE ls_result     STRING
   DEFINE lf_result     FLOAT
   DEFINE sr2           RECORD
                        ish   RECORD LIKE ish_file.*
                        END RECORD
   
   DECLARE t200_inv_g_detail_curs2 CURSOR FOR
     SELECT * FROM ish_file
       WHERE isb02 = p_isg01
        ORDER BY isb02
   IF STATUS THEN CALL cl_err('t200_inv_g_detail_curs2',STATUS,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   FOREACH t200_inv_g_detail_curs2 INTO sr2.*
      IF STATUS THEN
         CALL cl_err('t200_inv_g_detail_curs2',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF 
       #---------发票明细信息----------------------------------------------------------------------------------------------
       CALL  InvListInit()
           RETURNING ls_result
   
      #销售商品或劳务名称
       CALL  setListGoodsName(sr2.ish.ish03)
           RETURNING li_result
      
      #税目,4位数字,商品所属类别
       CALL  setListTaxItem(sr2.ish.ish10)  
           RETURNING li_result
      
      #规格型号
       CALL  setListStandard(sr2.ish.ish06)
           RETURNING li_result
   
      #计量单位
       CALL  setListUnit(sr2.ish.ish05)
           RETURNING li_result
  
      #数量
       CALL  setListNumber(sr2.ish.ish07)   
           RETURNING lf_result
  
      #单价
       CALL  setListPrice(sr2.ish.ish15) 
           RETURNING lf_result

      #金额，可不传(为0)，由接口软件计算，如传入则应符合计算关系
       CALL  setListAmount(0)  
           RETURNING lf_result
  
      #含税价标志，0位不含税价，1为含税价
       CALL  setListPriceKind(0) 
           RETURNING lf_result
    
      #税额，可不传(为0)，由接口软件计算，如传入则应符合计算关系
       CALL  setListTaxAmount(0)
           RETURNING lf_result
    
      #将本行加入明细表
       CALL  AddInvList() 
           RETURNING li_result
   END FOREACH

END FUNCTION
#No.FUN-D50034 ---Add--- End
