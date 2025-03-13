# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: atmp201.4gl
# Descriptions...: 出貨(通知)單整批生成作業
# Date & Author..: 06/01/23 By ice
# Modify.........: No.FUN-630102 06/03/31 By Sarah 畫面增加輸入oea1015(代送商),寫入oga_file時增加oga1016
# Modify.........: No.TQC-640088 06/04/08 By ice 單身返利資料一并生成,增加訂單/出貨類型
# Modify.........: NO.FUN-630015 06/05/24 BY yiting s_rdate2改 call s_rdatem.4gl
# Modify.........: No.FUN-660104 06/06/15 By Rayven cl_err改成cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: NO.FUN-670007 06/07/26 BY yiting oaz32->oax01
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680022 06/08/30 By Tracy s_rdatem()增加一個參數 
# Modify.........: No.TQC-690019 06/09/06 By day  q_oea4 改為q_oea04
# Modify.........: No.FUN-680120 06/09/11 By chen 類型轉換
# Modify.........: No.FUN-690124 06/10/16 By hongmei cl_used位置調整及EXIT PROGRAM后加cl_used 
# Modify.........: No.FUN-690044 06/10/23 By rainy 移除BU間銷售 
# Modify.........: No.FUN-6B0014 06/11/06 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.MOD-6B0168 06/12/12 By Sarah 轉出貨單時,科目別(oga13)帶客戶主檔中所設定的慣用科目(occ67)
# Modify.........: No.TQC-680074 06/12/27 By Smapmin 為因應s_rdatem.4gl程式內對於dbname的處理,故LET g_dbs2=g_dbs,'.'
# Modify.........: No.FUN-710033 07/02/11 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-730022 07/03/13 By rainy 流程自動化
# Modify.........: No.MOD-6B0131 07/04/03 By claire 出通單轉出貨單需帶入invocie no
# Modify.........: No.MOD-6B0132 07/04/03 By claire oga50帶不出來
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowi,改用單號
# Modify.........: No.FUN-7B0018 08/03/05 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.CHI-840002 08/04/02 By Carol default ogamksg(簽核) check單據性質檔設定
# Modify.........: No.FUN-8A0086 08/10/20 By lutingting如果是沒有let g_success = 'Y' 就寫給g_success 賦初始值，
#                                                      不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-920166 09/02/20 By alex g_dbs2改為使用s_dbstring
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980009 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Mofify.........: No.FUN-980020 09/09/10 By douzh 集團架構調整sub相關修改
# Modify.........: No.MOD-990102 09/09/10 By mike 當出通轉出貨時，不應該卡oga00 = '1'    
# Modify.........: No.           09/10/21 By lilingyu r.c2 fail
# Modify.........: No:CHI-9C0024 10/02/23 By Smapmin 加上拋轉多倉儲資料與批序號資料
# Modify.........: No:CHI-A40020 10/04/14 By Smapmin 備註資料也要一併拋轉
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ATM
# Modify.........: No.FUN-A60035 10/07/05 By chenls 服飾狀態下將款式明細資料插入ata_fiel中
# Modify.........: No.FUN-A60035 10/07/28 By chenls mark服飾版的ata_file
# Modify.........: No:MOD-A60163 10/07/30 By Smapmin oga909為空時,default為N
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0067 10/11/22 by destiny  增加倉庫的權限控管
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.TQC-AC0235 10/12/17 By wangxin 通知單/出貨單別按放大鏡開窗時無法選擇
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No:MOD-B30060 11/03/09 By Summer 訂單轉出貨單時，oga50,oga51無累加單身金額
# Modify.........: No:FUN-910088 11/12/21 By chenjing 增加數量欄位小數取位
# Modify.........: No:MOD-C30178 12/03/09 By yuhuabao 客戶編號簡稱應該由訂單號帶入
# Modify.........: No:MOD-C30489 12/03/13 By xumeimei 修改無法將 null 插入欄的 '欄-名稱'问题
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,新增t600sub_y_chk參數
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52       
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD			      # Print condition RECORD
          type         LIKE type_file.chr1,   # Prog. Version..: '5.30.06-13.03.12(01)              # Task type
          oga00        LIKE oga_file.oga00,   # Shipment type #TQC-640088
          wc           LIKE type_file.chr1000 #No.FUN-680120 VARCHAR(300)              # Where condition
      END RECORD,
   g_oea  RECORD       LIKE oea_file.*,       #訂單單頭
   g_oeb  RECORD       LIKE oeb_file.*,       #訂單單身
   g_oga  RECORD       LIKE oga_file.*,       #出貨單頭
   g_ogb  RECORD       LIKE ogb_file.*,       #出貨單身
   g_oga1 RECORD       LIKE oga_file.*,       #出貨單頭
   g_ogb1 RECORD       LIKE ogb_file.*,       #出貨單身
   g_oga01             LIKE oga_file.oga01,   #出貨單號
   g_ogamksg           LIKE oga_file.ogamksg, #簽核     #CHI-840002-add
   begin_no,end_no     LIKE oga_file.oga01,
   g_type              LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
   g_oga00             LIKE oga_file.oga00,   #No.TQC-640088
   g_buf               LIKE oay_file.oaytype, # Prog. Version..: '5.30.06-13.03.12(02)               #No.TQC-640088
   g_sql               LIKE type_file.chr1000           #No.FUN-680120 VARCHAR(800) 
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
DEFINE   g_argv1       LIKE type_file.chr1,             
         g_argv2       LIKE oga_file.oga00,                         
         g_argv3       LIKE oea_file.oea01,            
         g_argv4       LIKE oga_file.oga01,
         g_argv5       LIKE type_file.chr1,
         g_auto_doc    LIKE type_file.chr1,
         g_auto_conf   LIKE type_file.chr1
DEFINE   g_msg     STRING
DEFINE g_plant2        LIKE type_file.chr30   #FUN-980020 
 
 
MAIN
   DEFINE   li_result    LIKE type_file.num5      #TQC-730022
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
 #TQC-730022 begin
  LET g_argv1 = ARG_VAL(1)         #參數-1 作業類別
  LET g_argv2 = ARG_VAL(2)         #參數-2 出貨類別
  LET g_argv3 = ARG_VAL(3)         #參數-3 單據別
  LET g_argv4 = ARG_VAL(4)         #參數-4 背景作業
  LET g_argv5 = ARG_VAL(5)         #自動拋轉 "A"
  IF cl_null(g_argv5) THEN 
     LET g_argv5 = "N"
  END IF       
  LET g_auto_doc = g_argv5
  LET g_bgjob = ARG_VAL(6)                
  IF cl_null(g_bgjob) THEN
     LET g_bgjob = "N"
  END IF
  LET g_auto_conf = ARG_VAL(7)
  IF cl_null(g_auto_conf) THEN
    LET g_auto_conf = 'N'
  END IF
 #TQC-730022 end
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ATM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690124
 
  #TQC-730022 begin 
    IF g_bgjob = 'Y' THEN
      LET tm.type = g_argv1 CLIPPED
      LET tm.oga00 = g_argv2 CLIPPED
      IF tm.type = '3' THEN
        LET tm.wc = " oga01='",g_argv3 CLIPPED,"'"
      ELSE
        LET tm.wc = " oea01='",g_argv3 CLIPPED,"'"
      END IF 
      LET g_oga01 = g_argv4 CLIPPED
      IF tm.type = '2' THEN
         IF tm.oga00 MATCHES '[126]' THEN 
            CALL s_check_no("axm",g_oga01,"",'40',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
         IF tm.oga00 ='3' THEN
            CALL s_check_no("axm",g_oga01,"",'43',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
         IF tm.oga00 ='4' THEN
            CALL s_check_no("axm",g_oga01,"",'44',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
         IF tm.oga00 ='7' THEN
            CALL s_check_no("axm",g_oga01,"",'43',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
      ELSE
         IF tm.oga00 MATCHES '[126]' THEN
            CALL s_check_no('axm',g_oga01,"",'50',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
         IF tm.oga00 = '3' THEN
            CALL s_check_no('axm',g_oga01,"",'53',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
         IF tm.oga00 = '4' THEN
            CALL s_check_no('axm',g_oga01,"",'54',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
         IF tm.oga00 = '7' THEN
            CALL s_check_no('axm',g_oga01,"",'53',"oga_file","oga01","")
               RETURNING li_result,g_oga01
         END IF
      END IF
    END IF
 
   IF g_bgjob = "N" THEN
     CALL p201_tm()  
   ELSE
     LET g_success = 'Y'                   #No.FUN-8A0086
     CALL p201_process()
     LET g_msg = begin_no,'~',end_no, ' generated success'
     MESSAGE g_msg 
   END IF
  #TQC-730022 end
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690124  #No.FUN-6B0014
   EXIT PROGRAM                                                                                                                     
                                                                                                                                    
END MAIN
 
 
FUNCTION p201_tm()
 
   OPEN WINDOW p201_w WITH FORM "atm/42f/atmp201"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
#  #-----TQC-680074--------- 
#  IF cl_db_get_database_type() = 'IFX' THEN
#     LET g_dbs2 = g_dbs CLIPPED,':'
#  ELSE
#     LET g_dbs2 = g_dbs CLIPPED,'.'
#  END IF
#  #-----END TQC-680074-----
   LET g_plant2 = g_plant                    #FUN-980020
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)    #FUN-920166
 
   CALL p201()
   
   CLOSE WINDOW p201_w 
END FUNCTION
 
FUNCTION p201() 
   DEFINE l_flag       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
          l_i          LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          li_result    LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          g_t1         LIKE oay_file.oayslip
 
   LET g_type = "1"
   LET g_oga00 = "1"   #No.TQC-640088
   WHILE TRUE
      LET g_action_choice = ""
      CLEAR FORM
      LET tm.type = g_type
      LET tm.oga00 = g_oga00            #No.TQC-640088
      INPUT BY NAME tm.type,tm.oga00    #No.TQC-640088
 
         AFTER FIELD type
           IF tm.type NOT MATCHES '[123]' THEN
              NEXT FIELD type
           END IF
 
         #No.TQC-640088 --start--
         AFTER FIELD oga00
           #IF tm.oga00 NOT MATCHES '[1234567]' THEN  #FUN-690044
           IF tm.oga00 NOT MATCHES '[123467]' THEN    #FUN-690044
              NEXT FIELD oga00
           END IF
         #No.TQC-640088 --end--
 
         AFTER INPUT 
           IF tm.type NOT MATCHES '[123]' THEN
              NEXT FIELD type
           END IF
           #IF tm.oga00 NOT MATCHES '[1234567]' THEN  #FUN-690044
           IF tm.oga00 NOT MATCHES '[123467]' THEN    #FUN-690044
              NEXT FIELD oga00
           END IF
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about  
            CALL cl_about()
 
         ON ACTION help  
            CALL cl_show_help()
 
         ON ACTION controlg 
            CALL cl_cmdask() 
 
      END INPUT
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         RETURN 
      END IF
      LET g_type = tm.type 
      LET g_oga00 = tm.oga00   #No.TQC-640088
 
      CONSTRUCT BY NAME tm.wc ON oea01,oea03,oeb15,oea1015   #FUN-630102 add oea1015
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(oea01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  IF tm.type = '3' THEN 
                     LET g_qryparam.form ="q_oga01"
                     LET g_qryparam.where =" oga00 = '",tm.oga00,"' "  #No.TQC-640088
                  ELSE
#                    LET g_qryparam.form ="q_oea4"   #No.TQC-690019
                     LET g_qryparam.form ="q_oea04"  #No.TQC-690019
                     LET g_qryparam.where =" oea00 = '",tm.oga00,"' "  #No.TQC-640088
                  END IF
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea01
                  NEXT FIELD oea01
               WHEN INFIELD(oea03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_occ"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea03
                  NEXT FIELD oea03
              #start FUN-630102 add
               WHEN INFIELD(oea1015)   #代送商
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pmc8"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO oea1015
                  NEXT FIELD oea1015
              #end FUN-630102 add
               OTHERWISE EXIT CASE
            END CASE
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT CONSTRUCT
 
         ON ACTION exit
            LET INT_FLAG = 1
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
          
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         RETURN 
      END IF
      IF tm.wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF
      IF tm.type = '3' THEN
         FOR l_i = 1 TO 294
            IF tm.wc[l_i,l_i+4] = 'oea01' THEN
               LET tm.wc[l_i,l_i+4] = 'oga01'
            END IF 
            IF tm.wc[l_i,l_i+4] = 'oea03' THEN
               LET tm.wc[l_i,l_i+4] = 'oga03'
            END IF 
            IF tm.wc[l_i,l_i+4] = 'oeb15' THEN
               IF l_i = 1 THEN
                  LET tm.wc = 'ogb1003',tm.wc[l_i+5,300] CLIPPED
               ELSE
                  LET tm.wc = tm.wc[1,l_i-1],'ogb1003',tm.wc[l_i+5,300] CLIPPED
               END IF
            END IF
           #start FUN-630102 add
            IF tm.wc[l_i,l_i+6] = 'oea1015' THEN
               LET tm.wc[l_i,l_i+6] = 'oga1016'
            END IF 
           #end FUN-630102 add
         END FOR
      END IF
 
      LET begin_no = NULL 
      LET end_no   = NULL
      INPUT g_oga01 FROM oga01
         BEFORE INPUT 
            CALL cl_set_doctype_format("oga01")
 
         AFTER FIELD oga01 
            IF NOT cl_null(g_oga01) THEN
 
#CHI-840002-modify
               LET g_ogamksg = ''
               SELECT oayapr INTO g_ogamksg FROM oay_file
                WHERE oayslip = g_oga01 
               IF cl_null(g_ogamksg) THEN
                  LET g_ogamksg= 'N'                #簽核
               END IF 
#CHI-840002-modify-end
 
               IF tm.type = '2' THEN
                  IF tm.oga00 MATCHES '[126]' THEN 
                     CALL s_check_no("axm",g_oga01,"",'40',"oga_file","oga01","")
                        RETURNING li_result,g_oga01
                  END IF
                  IF tm.oga00 ='3' THEN
                     CALL s_check_no("axm",g_oga01,"",'43',"oga_file","oga01","")
                        RETURNING li_result,g_oga01
                  END IF
                  IF tm.oga00 ='4' THEN
                     CALL s_check_no("axm",g_oga01,"",'44',"oga_file","oga01","")
                        RETURNING li_result,g_oga01
                  END IF
                 #FUN-690044--remark begin
                  #IF tm.oga00 ='5' THEN
                  #   CALL s_check_no("axm",g_oga01,"",'46',"oga_file","oga01","")
                  #      RETURNING li_result,g_oga01
                  #END IF
                 #FUN-690044--end
                  IF tm.oga00 ='7' THEN
                     CALL s_check_no("axm",g_oga01,"",'43',"oga_file","oga01","")
                        RETURNING li_result,g_oga01
                  END IF
               ELSE
                  IF tm.oga00 MATCHES '[126]' THEN
#                    CALL s_check_no(g_sys,g_oga01,"",'50',"oga_file","oga01","")
                     CALL s_check_no("axm",g_oga01,"",'50',"oga_file","oga01","")  #No.FUN-A40041
                        RETURNING li_result,g_oga01
                  END IF
                  IF tm.oga00 = '3' THEN
#                    CALL s_check_no(g_sys,g_oga01,"",'53',"oga_file","oga01","")
                     CALL s_check_no("axm",g_oga01,"",'53',"oga_file","oga01","")  #No.FUN-A40041
                        RETURNING li_result,g_oga01
                  END IF
                  IF tm.oga00 = '4' THEN
#                    CALL s_check_no(g_sys,g_oga01,"",'54',"oga_file","oga01","")
                     CALL s_check_no("axm",g_oga01,"",'54',"oga_file","oga01","")  #No.FUN-A40041
                        RETURNING li_result,g_oga01
                  END IF
                 #FUN-690044 remark begin
                  #IF tm.oga00 = '5' THEN
                  #   CALL s_check_no(g_sys,g_oga01,"",'56',"oga_file","oga01","")
                  #      RETURNING li_result,g_oga01
                  #END IF
                 #FUN-690044 --end
                  IF tm.oga00 = '7' THEN
#                    CALL s_check_no(g_sys,g_oga01,"",'53',"oga_file","oga01","")
                     CALL s_check_no("axm",g_oga01,"",'53',"oga_file","oga01","")  #No.FUN-A40041
                        RETURNING li_result,g_oga01
                  END IF
                  #No.TQC-640088 --end--
               END IF
               DISPLAY g_oga01 TO oga01
               IF (NOT li_result) THEN
                  NEXT FIELD oga01
               END IF
            END IF
 
         ON ACTION CONTROLP
            #No.TQC-640088 --start--
            CASE 
               WHEN tm.type = '2' AND tm.oga00 != '7' 
                  LET g_buf='40' 
               WHEN tm.type MATCHES '[13]' AND tm.oga00 != '7'
                  LET g_buf='50'
               WHEN tm.type = '2' AND tm.oga00 = '7' 
                  LET g_buf='43'
               WHEN tm.type MATCHES '[13]' AND tm.oga00 = '7'
                  LET g_buf='53'
            END CASE
            IF tm.oga00 = '3' THEN LET g_buf[2,2] = '3' END IF
            IF tm.oga00 = '4' THEN LET g_buf[2,2] = '4' END IF
           #IF tm.oga00 = '5' THEN LET g_buf[2,2] = '6' END IF  #FUN-690044 remark
           #CALL q_oay(FALSE,FALSE,g_t1,g_buf,g_sys) RETURNING g_t1  #TQC-670008
           # CALL q_oay(FALSE,FALSE,g_t1,g_buf,'ATM') RETURNING g_t1  #TQC-670008
           CALL q_oay(FALSE,FALSE,g_t1,g_buf,'AXM') RETURNING g_t1  #TQC-AC0235
            #No.TQC-640088 --end--
            LET g_oga01 = g_t1
            DISPLAY g_oga01 TO oga01
            NEXT FIELD oga01
 
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about  
            CALL cl_about()
 
         ON ACTION help  
            CALL cl_show_help()
 
         ON ACTION controlg 
            CALL cl_cmdask() 
 
      END INPUT
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         RETURN 
      END IF
 
      IF cl_sure(20,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p201_process()
         CALL s_showmsg()        #No.FUN-710033
         IF g_success = 'Y' THEN
            DISPLAY begin_no TO start_no
            DISPLAY end_no TO end_no
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN 
            CONTINUE WHILE
         ELSE
            EXIT WHILE 
         END IF
      END IF
   END WHILE
END FUNCTION
 
FUNCTION p201_process()
   CASE tm.type 
      WHEN "1"
         LET g_sql = " SELECT DISTINCT oea_file.*  ",
                     "   FROM oea_file,oeb_file ",
                     "  WHERE oea01 = oeb01 ",
                     "    AND oea49 = '1' AND oeaconf = 'Y' ",
                     "    AND oeb70 = 'N' ",
                     "    AND oeb24 = 0 ",
                     "    AND oea00 = '",tm.oga00,"' ",   #No.TQC-640088
                     "    AND oea01 NOT IN " ,
                     "(SELECT oga16 ",
                     "   FROM oga_file ",
                     "  WHERE oga09 IN ('2','3','4','6') ", 
                     "    AND ogaconf <> 'X' ",
                     "    AND oga16 IS NOT NULL) " ,
                     "    AND ", tm.wc CLIPPED, 
                     "  ORDER BY oea01 "
      WHEN "2"
         LET g_sql = " SELECT DISTINCT oea_file.*  ",
                     "   FROM oea_file,oeb_file ",
                     "  WHERE oea01 = oeb01 ",
                     "    AND oea49 = '1' AND oeaconf = 'Y' ",
                     "    AND oeb70 = 'N' ",
                     "    AND oeb24 = 0 ",
                     #"    AND oeb1003 = '1' ",          #TQC-640088
                     "    AND oea00 = '",tm.oga00,"' ",  #TQC-640088
                     "    AND oea01 NOT IN ",
                     "(SELECT oga16 ",
                     "   FROM oga_file ",
                     "  WHERE ogaconf <> 'X' ",
                     "    AND oga16 IS NOT NULL) " ,          
                     "    AND ", tm.wc CLIPPED, 
                     "  ORDER BY oea01 "
      WHEN "3"
         LET g_sql = " SELECT DISTINCT oga_file.*  ",
                     "   FROM oga_file,ogb_file ",
                     "  WHERE oga01 = ogb01 ",
                     "    AND oga09 = '1' AND ogaconf = 'Y' ",
                    #"    AND oga00 = '1' ",   #正常出貨 #MOD-990102   
                     "    AND oga00 = '",tm.oga00,"' ",  #MOD-990102       
                     " AND oga01 NOT IN" ,
                     "(SELECT oga011  ",
                     "   FROM oga_file ",
                     "  WHERE oga09 IN ('2','3','4','6') ", 
                     "    AND ogaconf <> 'X' AND oga011 IS NOT NULL) " ,
                     "    AND ", tm.wc CLIPPED, 
                     "  ORDER BY oga01 "
   END CASE
 
   PREPARE p201_prepare FROM g_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p201_cs CURSOR WITH HOLD FOR p201_prepare
   IF tm.type = '3' THEN 
      CALL s_showmsg_init()      #NO. FUN-710033
      FOREACH p201_cs INTO g_oga1.* 
      #NO. FUN-710033--BEGIN          
      IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
      END IF
      #NO. FUN-710033--END
         IF SQLCA.sqlcode THEN 
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            LET g_success = 'N'
            RETURN 
         END IF
         CALL p201_ins_oga()
        # CALL p201_ins_ata(g_oga1.oga01)     #FUN-A60035 add  #FUN-A60035 ---MARK
         INITIALIZE g_oga.*  LIKE oga_file.*   #DEFAULT 設定
         INITIALIZE g_oga1.* LIKE oga_file.*   #DEFAULT 設定
      END FOREACH
    #NO. FUN-710033--BEGIN
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
    #NO. FUN-710033--END 
   ELSE
      FOREACH p201_cs INTO g_oea.* 
#NO. FUN-710033--BEGIN          
IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
#NO. FUN-710033--END
      IF SQLCA.sqlcode THEN 
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)         #NO. FUN-710033
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1) #NO. FUN-710033
            LET g_success = 'N'
            RETURN 
         END IF
         CALL p201_ins_oga()
         CALL p201_upd_oga()
        # CALL p201_ins_ata(g_oea.oea01)     #FUN-A60035 add  #FUN-A60035 ---MARK
         INITIALIZE g_oga.* LIKE oga_file.*   #DEFAULT 設定
         INITIALIZE g_oea.* LIKE oea_file.*   #DEFAULT 設定
      END FOREACH
 #NO. FUN-710033--BEGIN
     IF g_totsuccess="N" THEN
        LET g_success="N"
     END IF
    #NO. FUN-710033--END 
 
  END IF
   IF cl_null(begin_no) THEN
      CALL cl_err('','aap-129',1)
      LET g_success = 'N'
   END IF
END FUNCTION

#FUN-A60035 ---MARK BEGIN
##FUN-A60035 add begin
#FUNCTION p201_ins_ata(p_ata01)
#  DEFINE l_prog1    LIKE ata_file.ata00
#  DEFINE l_prog2    LIKE ata_file.ata00
#  DEFINE l_n        LIKE type_file.num5
#  DEFINE p_ata01    LIKE ata_file.ata01

#  IF NOT s_industry("slk") OR cl_null(p_ata01) THEN
#     RETURN
#  END IF
#  CASE tm.type
#     WHEN "1" 
#        LET l_prog1 = "axmt410_slk"
#        LET l_prog2 = "axmt620_slk"
#     WHEN "2"
#        LET l_prog1 = "axmt410_slk"
#        LET l_prog2 = "axmt610_slk"
#     WHEN "3"
#        LET l_prog1 = "axmt610_slk"
#        LET l_prog2 = "axmt620_slk"
#  END CASE
#  SELECT count(*) INTO l_n FROM ata_file
#   WHERE ata00 = l_prog1
#     AND ata01 = p_ata01
#  IF l_n = 0 THEN
#     RETURN
#  END IF
#  DROP TABLE x
#  SELECT * FROM ata_file
#   WHERE ata00 = l_prog1
#     AND ata01 = p_ata01 
#  INTO TEMP x
#  UPDATE x SET ata00 = l_prog2,
#               ata01 = g_oga.oga01
#  INSERT INTO ata_file
#    SELECT * FROM x

#END FUNCTION
##FUN-A60035 add end
#FUN-A60035 ---MARK END
 
FUNCTION p201_ins_oga()
   #DEFINE l_oaz32   LIKE oaz_file.oax01,   #三角貿易使用匯率 S/B/C/D     #NO.FUN-670007
   DEFINE l_oax01   LIKE oax_file.oax01,   #三角貿易使用匯率 S/B/C/D      #NO.FUN-670007
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,             #No.FUN-680120 SMALLINT
          exT       LIKE type_file.chr1,             #No.FUN-680120 VARCHAR(01)
          l_date1   LIKE type_file.dat,              #No.FUN-680120 DATE
          l_date2   LIKE type_file.dat               #No.FUN-680120 DATE
    DEFINE l_oao    RECORD LIKE oao_file.*   #CHI-A40020
   
  #MOD-B30060 mark --start--
  ##Default初植
  ##MOD-6B0132-begin-add
  # LET g_oga.oga50  = 0                  #原幣出貨金額
  # LET g_oga.oga501 = 0                  #本幣出貨金額
  # LET g_oga.oga51  = 0                  #原幣出貨金額(含稅)
  # LET g_oga.oga511 = 0                  #本幣出貨金額 
  # LET g_oga.oga52  = 0                  #原幣預收訂金轉銷貨收入金額
  # LET g_oga.oga53  = 0                  #原幣應開發票未稅金額
  # LET g_oga.oga54  = 0                  #原幣已開發票未稅金額 
  ##MOD-6B0132-end-add
  #MOD-B30060 mark --end--
   IF tm.type = '3' THEN
      LET g_oga.oga00  = g_oga1.oga00
      LET g_oga.oga011 = g_oga1.oga01    
      LET g_oga.oga021 = g_today
      LET g_oga.oga03  = g_oga1.oga03
      LET g_oga.oga032 = g_oga1.oga032
      LET g_oga.oga033 = g_oga1.oga033
      LET g_oga.oga04  = g_oga1.oga04
      LET g_oga.oga044 = g_oga1.oga044
      LET g_oga.oga05  = g_oga1.oga05
      LET g_oga.oga06  = g_oga1.oga06
      LET g_oga.oga07  = g_oga1.oga07
      LET g_oga.oga08  = g_oga1.oga08
      LET g_oga.oga09  = '2'             #單據別:一般出貨單
      LET g_oga.oga1001= g_oga1.oga1001
      LET g_oga.oga1002= g_oga1.oga1002
      LET g_oga.oga1003= g_oga1.oga1003
      LET g_oga.oga1004= g_oga1.oga1004
      LET g_oga.oga1005= g_oga1.oga1005
      LET g_oga.oga1009= g_oga1.oga1009
      LET g_oga.oga1010= g_oga1.oga1010
      LET g_oga.oga1011= g_oga1.oga1011
      LET g_oga.oga1016= g_oga1.oga1016   #FUN-630102 add
      LET g_oga.oga14  = g_oga1.oga14
      LET g_oga.oga15  = g_oga1.oga15
      LET g_oga.oga16  = g_oga1.oga16
      LET g_oga.oga161 = g_oga1.oga161
      LET g_oga.oga162 = g_oga1.oga162
      LET g_oga.oga163 = g_oga1.oga163
      LET g_oga.oga18  = g_oga1.oga18
      LET g_oga.oga21  = g_oga1.oga21
      LET g_oga.oga211 = g_oga1.oga211
      LET g_oga.oga212 = g_oga1.oga212
      LET g_oga.oga213 = g_oga1.oga213
      LET g_oga.oga23  = g_oga1.oga23
      LET g_oga.oga24  = g_oga1.oga24
      LET g_oga.oga25  = g_oga1.oga25
      LET g_oga.oga26  = g_oga1.oga26
      LET g_oga.oga27  = g_oga1.oga27      #MOD-6B0131
      LET g_oga.oga31  = g_oga1.oga31
      LET g_oga.oga32  = g_oga1.oga32
      LET g_oga.oga41  = g_oga1.oga41
      LET g_oga.oga42  = g_oga1.oga42
      LET g_oga.oga43  = g_oga1.oga43
      LET g_oga.oga44  = g_oga1.oga44
      LET g_oga.oga45  = g_oga1.oga45
      LET g_oga.oga46  = g_oga1.oga46
     #MOD-6B0132-begin-add
      LET g_oga.oga50  = g_oga1.oga50       #原幣出貨金額
      LET g_oga.oga501 = g_oga1.oga501      #本幣出貨金額
      LET g_oga.oga51  = g_oga1.oga51       #原幣出貨金額(含稅)
      LET g_oga.oga511 = g_oga1.oga511      #本幣出貨金額 
      LET g_oga.oga52  = g_oga1.oga52       #原幣預收訂金轉銷貨收入金額
      LET g_oga.oga53  = g_oga1.oga53       #原幣應開發票未稅金額
      LET g_oga.oga54  = g_oga1.oga54       #原幣已開發票未稅金額 
     #MOD-6B0132-end-add
      LET g_oga.oga909 = g_oga1.oga909
      LET g_oga.oga65  = g_oga1.oga65
      LET g_oga.oga57 = '1'                 #MOD-C30489
      LET g_oga.oga55 = '0'                 #MOD-C30489
      LET g_oga.oga903 = 'N'                #MOD-C30489
   ELSE
      LET g_oga.oga00  = g_oea.oea00        #類別
      LET g_oga.oga011 = ''                 #出貨通知單號
      LET g_oga.oga021 = ''                 #結關日期 
      LET g_oga.oga03  = g_oea.oea03        #帳款客戶編號
      LET g_oga.oga04  = g_oea.oea04        #送貨客戶編號
      LET g_oga.oga044 = g_oea.oea044       #送貨地址碼
      LET g_oga.oga05  = g_oea.oea05        #發票別
      LET g_oga.oga06  = g_oea.oea06        #訂單維護作業預設起始版本編號
      LET g_oga.oga07  = g_oea.oea07        #出貨是否計入未開發票的銷貨待驗收入
      LET g_oga.oga08  = g_oea.oea08        #內/外銷
      LET g_oga.oga1001= g_oea.oea1001
      LET g_oga.oga1002= g_oea.oea1002
      LET g_oga.oga1003= g_oea.oea1003
      LET g_oga.oga1004= g_oea.oea1004
      LET g_oga.oga1005= g_oea.oea1005
      LET g_oga.oga1007= 0
      LET g_oga.oga1008= 0
      LET g_oga.oga1009= g_oea.oea1009
      LET g_oga.oga1010= g_oea.oea1010
      LET g_oga.oga1011= g_oea.oea1011
      LET g_oga.oga1016= g_oea.oea1015      #FUN-630102 add
      LET g_oga.oga14  = g_oea.oea14        #人員編號
      LET g_oga.oga15  = g_oea.oea15        #部門編號
      LET g_oga.oga16  = g_oea.oea01        #訂單號碼
      LET g_oga.oga161 = g_oea.oea161       #訂金應收比率
      LET g_oga.oga162 = g_oea.oea162       #出貨應收比率
      LET g_oga.oga163 = g_oea.oea163       #尾款應收比率
      LET g_oga.oga18  = g_oea.oea17        #收款客戶編號
      LET g_oga.oga21  = g_oea.oea21        #稅別
      LET g_oga.oga211 = g_oea.oea211       #稅率
      LET g_oga.oga212 = g_oea.oea212       #聯數
      LET g_oga.oga213 = g_oea.oea213       #含稅否
      LET g_oga.oga23  = g_oea.oea23        #幣別
      LET g_oga.oga25  = g_oea.oea25        #銷售分類一
      LET g_oga.oga26  = g_oea.oea26        #銷售分類二
      LET g_oga.oga31  = g_oea.oea31        #價格條件編碼
      LET g_oga.oga32  = g_oea.oea32        #收款條件編碼
      LET g_oga.oga41  = g_oea.oea41        #起運地
      LET g_oga.oga42  = g_oea.oea42        #到達地
      LET g_oga.oga43  = g_oea.oea43        #交運方式
      LET g_oga.oga44  = g_oea.oea44        #嘜頭編號
      LET g_oga.oga45  = g_oea.oea45        #聯絡人
      LET g_oga.oga46  = g_oea.oea46        #專案編號
      #MOD-B30060 add --start--
      LET g_oga.oga50  = 0                  #原幣出貨金額
      LET g_oga.oga501 = 0                  #本幣出貨金額
      LET g_oga.oga51  = 0                  #原幣出貨金額(含稅)
      LET g_oga.oga511 = 0                  #本幣出貨金額 
      LET g_oga.oga52  = 0                  #原幣預收訂金轉銷貨收入金額
      LET g_oga.oga53  = 0                  #原幣應開發票未稅金額
      LET g_oga.oga54  = 0                  #原幣已開發票未稅金額 
      #MOD-B30060 add --end--
      LET g_oga.oga55  = '0'                #狀況碼
      LET g_oga.oga903 = 'N'                #信用查核放行否
      LET g_oga.oga909 = g_oea.oea901       #三角貿易否
      LET g_oga.oga65  = g_oea.oea65
      LET g_oga.oga57 = '1'                 #FUN-AC0055 add
      LET g_oga.oga032 = g_oea.oea032        #MOD-C30178 add
      LET g_oga.oga033 = g_oea.oea033        #MOD-C30178 add
      #匯率
#NO.FUN-670007 start--
#      SELECT oax01,oaz52,oaz70 INTO l_oax01,l_oaz52,l_oaz70 FROM oaz_file
      SELECT oax01 INTO l_oax01 FROM oax_file
      SELECT oaz52,oaz70 INTO l_oaz52,l_oaz70 FROM oaz_file
#NO.FUN-670007 end---
      IF g_oga.oga08='1' THEN 
         LET exT = l_oaz52 
      ELSE 
         LET exT = l_oaz70 
      END IF
      IF g_oga.oga909 = 'Y' THEN 
         #LET exT = l_oaz32      #NO.FUN-670007 
         LET exT = l_oax01       #NO.FUN-670007
      END IF
      CALL s_curr3(g_oga.oga23,g_oga.oga021,exT)
         RETURNING g_oga.oga24
      IF tm.type = '1' THEN                 #訂單轉出貨單
         LET g_oga.oga09  = '2'             #單據別:一般出貨單
      ELSE                                  #訂單轉通知單
         LET g_oga.oga09  = '1'             #單據別:出貨通知單
         LET g_oga.oga1015 = '0'
      END IF
   END IF
   LET g_oga.oga02  = g_today            #出貨日期
   LET g_oga.oga69  = g_today            #輸入日期 #TQC-730022 add
   LET g_oga.oga022 = ''                 #裝船日期
   LET g_oga.oga10  = ''                 #帳單編號
   LET g_oga.oga1006= 0
   LET g_oga.oga1013= 'N'
  #LET g_oga.oga13  = ''                 #科目分類碼                     #MOD-6B0168 mark
   SELECT occ67 INTO g_oga.oga13 FROM occ_file WHERE occ01=g_oga.oga03   #MOD-6B0168
   IF cl_null(g_oga.oga13) THEN LET g_oga.oga13  = '' END IF             #MOD-6B0168
   LET g_oga.oga17  = ''                 #排貨模擬順序 
   LET g_oga.oga20  = 'Y'                #分錄底稿是否可重新產生
  #LET g_oga.oga27  = ''                 #Invoice No.                    #MOD-6B0131 mark
   LET g_oga.oga28  = ''                 #立帳時采用訂單匯率
   LET g_oga.oga29  = ''                 #信用額度余額
   LET g_oga.oga30  = 'N'                #包裝單確認碼
  #MOD-6B0132-begin-mark
  #LET g_oga.oga50  = 0                  #原幣出貨金額
  #LET g_oga.oga501 = 0                  #本幣出貨金額
  #LET g_oga.oga51  = 0                  #原幣出貨金額(含稅)
  #LET g_oga.oga511 = 0                  #本幣出貨金額 
  #LET g_oga.oga52  = 0                  #原幣預收訂金轉銷貨收入金額
  #LET g_oga.oga53  = 0                  #原幣應開發票未稅金額
  #LET g_oga.oga54  = 0                  #原幣已開發票未稅金額 
  #MOD-6B0132-end-mark
   LET g_oga.oga905 = 'N'                #已轉三角貿易出貨單否
   LET g_oga.oga906 = 'Y'                #起始出貨單否
   LET g_oga.oga99  = ''                 #多角貿易流程序號
   LET g_oga.ogaconf= 'N'                #確認否/作廢碼
   LET g_oga.ogapost= 'N'                #出貨扣帳否
   LET g_oga.ogaprsw= 0                  #列印次數
   LET g_oga.ogauser= g_user             #資料所有者
   LET g_oga.ogagrup= g_grup             #資料所有部門
   LET g_oga.ogamodu= ''                 #資料修改者
   LET g_oga.ogadate= g_today            #最近修改日
   LET g_oga.ogamksg= g_ogamksg          #簽核   #CHI-840002-modify
#MOD-C30178 ----- mark ----- begin
#  #帳款客戶簡稱,帳款客戶統一編號
#  SELECT occ02,occ11    
#    INTO g_oga.oga032,g_oga.oga033
#    FROM occ_file
#   WHERE occ01 = g_oga.oga03
#MOD-C30178 ----- mark ----- end
   #待扺帳款-預收單號
   SELECT oma01 INTO g_oga.oga19 
     FROM oma_file 
    WHERE oma10 = g_oga.oga16
   #應收款日,容許票據到期日
   #CALL s_rdate2(g_oga.oga03,g_oga.oga32,g_oga.oga02,g_oga.oga02)
   CALL s_rdatem(g_oga.oga03,g_oga.oga32,g_oga.oga02,g_oga.oga02,
                 #g_oea.oea02,g_dbs)   #NO.FUN-630015 #No.FUN-680022 add oea02   #TQC-680074
#                g_oea.oea02,g_dbs2)   #NO.FUN-630015 #No.FUN-680022 add oea02   #TQC-680074  #FUN-980020
                 g_oea.oea02,g_plant2) #FUN-980020
      RETURNING l_date1,l_date2
   IF cl_null(g_oga.oga11) THEN 
      LET g_oga.oga11 = l_date1 
   END IF
   IF cl_null(g_oga.oga12) THEN 
      LET g_oga.oga12 = l_date2 
   END IF
#No.FUN-870007-start-
   IF cl_null(g_oga.oga85) THEN
      LET g_oga.oga85=' '
   END IF
   IF cl_null(g_oga.oga94) THEN
      LET g_oga.oga94='N'
   END IF
#No.FUN-870007--end--
   
   CALL s_auto_assign_no("axm",g_oga01,g_oga.oga02,"","oga_file","oga01","","","")
     RETURNING li_result,g_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   LET g_oga.ogaplant = g_plant  #FUN-980009
   LET g_oga.ogalegal = g_legal  #FUN-980009
   LET g_oga.ogaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oga.ogaorig = g_grup      #No.FUN-980030 10/01/04
   IF cl_null(g_oga.oga909) THEN LET g_oga.oga909 = 'N' END IF  #MOD-A60163 
   INSERT INTO oga_file VALUES(g_oga.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p201_ins_oga():',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
#     CALL cl_err3("ins","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","p201_ins_oga():",1)  #No.FUN-660104  #NO. FUN-710033
      CALL s_errmsg('','','',SQLCA.sqlcode,1)      #NO. FUN-710033                                                    
      LET g_success = 'N'
      RETURN
   END IF
   #-----CHI-A40020---------
   IF tm.type = '3' THEN
      LET g_sql = " SELECT * FROM oao_file WHERE oao01 = '",g_oga.oga011,"'"
   ELSE
      LET g_sql = " SELECT * FROM oao_file WHERE oao01 = '",g_oga.oga16,"'"
   END IF
   PREPARE oao_p1 FROM g_sql
   DECLARE oao_c1 CURSOR WITH HOLD FOR oao_p1
   FOREACH oao_c1 INTO l_oao.*
      LET l_oao.oao01 = g_oga.oga01
      INSERT INTO oao_file VALUES (l_oao.*)
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('','','',SQLCA.sqlcode,1)                                                         
         LET g_success = 'N'
         RETURN
      END IF
   END FOREACH
   #-----END CHI-A40020-----
   IF cl_null(begin_no) THEN 
      LET begin_no = g_oga.oga01
   END IF
   LET end_no=g_oga.oga01
   IF tm.type = '3' THEN 
      LET g_sql = "SELECT * FROM ogb_file WHERE ogb01 = '",g_oga1.oga01,"' " 
   ELSE
      LET g_sql = "SELECT * FROM oeb_file WHERE oeb01 = '",g_oea.oea01,"' " 
   END IF
   PREPARE p201_prepare1 FROM g_sql
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('prepare1:',SQLCA.sqlcode,1)  #NO. FUN-710033
      CALL s_errmsg('','','',SQLCA.sqlcode,1)   #NO. FUN-710033 
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p201_cs1 CURSOR WITH HOLD FOR p201_prepare1
   IF tm.type = '3' THEN 
      FOREACH p201_cs1 INTO g_ogb1.* 
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)          #NO. FUN-710033
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  #NO. FUN-710033   
            LET g_success = 'N'
            RETURN 
         END IF
         IF g_ogb1.ogb1005 = '1' AND g_ogb1.ogb12 <= 0 THEN
            CONTINUE FOREACH
         END IF
         #TQC-640088 --start--
         #現返
	 IF g_ogb1.ogb1005 = '2' AND (g_ogb1.ogb14 = 0 OR g_ogb1.ogb14t = 0) THEN 
            CONTINUE FOREACH
         END IF
         #TQC-640088 --end--
         CALL p201_ins_ogb()
         #-----CHI-9C0024---------
         DROP TABLE x
         SELECT * FROM ogc_file WHERE ogc01 = g_oga.oga011 INTO TEMP x
         IF STATUS THEN
            CALL s_errmsg('','',"sel ogc",SQLCA.sqlcode,1)   
            LET g_success = 'N'
            RETURN 
         END IF
         UPDATE x SET ogc01=g_oga.oga01
         IF STATUS THEN
            CALL s_errmsg('','',"upd x",SQLCA.sqlcode,1)   
            LET g_success = 'N'
            RETURN 
         END IF
         INSERT INTO ogc_file SELECT * FROM x
                 WHERE ogc03 IN (SELECT ogb03 FROM ogb_file WHERE ogb01=g_oga.oga01)
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL s_errmsg('','',"ins ogc",SQLCA.sqlcode,1)   
            LET g_success = 'N'
            RETURN 
         END IF
         IF g_sma.sma115 = 'Y' THEN 
            DROP TABLE x
            SELECT * FROM ogg_file WHERE ogg01 = g_oga.oga011 INTO TEMP x
            IF STATUS THEN 
               CALL s_errmsg('','',"sel ogg",SQLCA.sqlcode,1)   
               LET g_success = 'N'
               RETURN 
            END IF
            UPDATE x SET ogg01=g_oga.oga01
            IF STATUS THEN 
               CALL s_errmsg('','',"upd x",SQLCA.sqlcode,1)   
               LET g_success = 'N'
               RETURN 
            END IF
            INSERT INTO ogg_file SELECT * FROM x 
                    WHERE ogg03 IN (SELECT ogb03 FROM ogb_file WHERE ogb01=g_oga.oga01)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"ins ogg",SQLCA.sqlcode,1)   
               LET g_success = 'N'
               RETURN 
            END IF
         END IF
         #-----END CHI-9C0024-----
         INITIALIZE g_ogb.*  LIKE ogb_file.*   #DEFAULT 設定
         INITIALIZE g_ogb1.* LIKE ogb_file.*   #DEFAULT 設定
      END FOREACH
   ELSE
      FOREACH p201_cs1 INTO g_oeb.* 
         IF SQLCA.sqlcode THEN 
#           CALL cl_err('prepare:',SQLCA.sqlcode,1)          #NO. FUN-710033 
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  #NO. FUN-710033     
            LET g_success = 'N'
            RETURN 
         END IF
         IF g_oeb.oeb1003 = '1' AND g_oeb.oeb12 <= 0 THEN
            CONTINUE FOREACH
         END IF
         #現返
	 IF g_oeb.oeb1003 = '2' AND (g_oeb.oeb14 = 0 OR g_oeb.oeb14t = 0) THEN  #TQC-640088
            CONTINUE FOREACH
         END IF
         CALL p201_ins_ogb()
         INITIALIZE g_ogb.* LIKE ogb_file.*   #DEFAULT 設定
         INITIALIZE g_oeb.* LIKE oeb_file.*   #DEFAULT 設定
      END FOREACH
   END IF
 
 
  #TQC-730022 begin  #處理自動確認段
   IF g_auto_conf = 'Y' THEN
 #     SELECT ROWI INTO l_oga_rowi FROM oga_file WHERE oga01 = g_oga.oga01  #091021
      CALL t600sub_y_chk(g_oga.oga01,'')    #CALL 原saxmt600確認的 check 段 #FUN-740034 #CHI-C30118 add ''
      IF g_success = "Y" THEN
         CALL t600sub_y_upd(g_oga.oga01,'') #CALL 原saxmt600確認的 update 段 #FUN-740034
      END IF
   END IF
　#TQC-730022 end
END FUNCTION
 
FUNCTION p201_ins_ogb()
   DEFINE l_flag   LIKE type_file.num5,    #No.FUN-680120 SMALLINT
          l_ima25  LIKE ima_file.ima25
   DEFINE l_ogbi   RECORD LIKE ogbi_file.* #No.FUN-7B0018
   #-----CHI-9C0024---------
   DEFINE l_ima918 LIKE ima_file.ima918,
          l_ima921 LIKE ima_file.ima921,
          l_rvbs   RECORD LIKE rvbs_file.*,
          l_rvbs06a LIKE rvbs_file.rvbs06,
          l_rvbs06b LIKE rvbs_file.rvbs06 
   #-----END CHI-9C0024-----
 
   #Default初植
   IF tm.type = '3' THEN
      LET g_ogb.ogb01  = g_oga.oga01
      LET g_ogb.ogb03  = g_ogb1.ogb03
      LET g_ogb.ogb04  = g_ogb1.ogb04
      LET g_ogb.ogb05  = g_ogb1.ogb05
      LET g_ogb.ogb05_fac = g_ogb1.ogb05_fac
      LET g_ogb.ogb06  = g_ogb1.ogb06     
      LET g_ogb.ogb07  = g_ogb1.ogb07
      LET g_ogb.ogb08  = g_ogb1.ogb08
      LET g_ogb.ogb09  = g_ogb1.ogb09
      LET g_ogb.ogb091 = g_ogb1.ogb091
      LET g_ogb.ogb092 = g_ogb1.ogb092
      LET g_ogb.ogb1001= g_ogb1.ogb1001
      LET g_ogb.ogb1002= g_ogb1.ogb1002
      LET g_ogb.ogb1003= g_ogb1.ogb1003
      LET g_ogb.ogb1004= g_ogb1.ogb1004
      LET g_ogb.ogb1005= g_ogb1.ogb1005
      LET g_ogb.ogb1006= g_ogb1.ogb1006
      LET g_ogb.ogb1007= g_ogb1.ogb1007
      LET g_ogb.ogb1008= g_ogb1.ogb1008
      LET g_ogb.ogb1009= g_ogb1.ogb1009
      LET g_ogb.ogb1010= g_ogb1.ogb1010
      LET g_ogb.ogb1011= g_ogb1.ogb1011                
      LET g_ogb.ogb1012= g_ogb1.ogb1012                
      LET g_ogb.ogb11  = g_ogb1.ogb11
      LET g_ogb.ogb12  = g_ogb1.ogb12 
      LET g_ogb.ogb13  = g_ogb1.ogb13
      LET g_ogb.ogb14  = g_ogb1.ogb14
      LET g_ogb.ogb14t = g_ogb1.ogb14t 
      LET g_ogb.ogb31  = g_ogb1.ogb31  
      LET g_ogb.ogb32  = g_ogb1.ogb32  
      LET g_ogb.ogb908 = g_ogb1.ogb908
      LET g_ogb.ogb910 = g_ogb1.ogb910
      LET g_ogb.ogb911 = g_ogb1.ogb911
      LET g_ogb.ogb912 = g_ogb1.ogb912
      LET g_ogb.ogb913 = g_ogb1.ogb913
      LET g_ogb.ogb914 = g_ogb1.ogb914
      LET g_ogb.ogb915 = g_ogb1.ogb915
      LET g_ogb.ogb916 = g_ogb1.ogb916
      LET g_ogb.ogb917 = g_ogb1.ogb917
      LET g_ogb.ogb19  = g_ogb1.ogb19
      #-----CHI-9C0024---------
      LET g_ogb.ogb17  = g_ogb1.ogb17     
      LET l_ima918 = ''   
      LET l_ima921 = ''  
      SELECT ima918,ima921 INTO l_ima918,l_ima921 
        FROM ima_file
       WHERE ima01 = g_ogb.ogb04
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         DECLARE p201_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                        WHERE rvbs01 = g_oga.oga011
                                          AND rvbs02 = g_ogb.ogb03
         
         FOREACH p201_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
         
            LET l_rvbs.rvbs00 = 'axmt620' 
            LET l_rvbs.rvbs01 = g_oga.oga01
         
            #檢查出貨數必須 =通知單應出數-累計出貨數
            #對應到的出貨通知單上的數量
            LET l_rvbs06a = 0

            SELECT SUM(rvbs06) INTO l_rvbs06a
              FROM rvbs_file
             WHERE rvbs01= g_oga.oga011
               AND rvbs02= g_ogb.ogb03
               AND rvbs13 = l_rvbs.rvbs13   
               AND rvbs09 = -1  
               AND rvbs022 = l_rvbs.rvbs022  
            
            IF cl_null(l_rvbs06a) THEN
               LET l_rvbs06a = 0
            END IF

            # 此出貨通知單已耗用在出貨單的量
            LET l_rvbs06b = 0

            SELECT SUM(rvbs06) INTO l_rvbs06b
              FROM ogb_file,oga_file,rvbs_file
             WHERE ogb01 = oga01 AND oga09 IN ('2','4','6') 
               AND oga011 = g_oga.oga011
               AND ogb03 = g_ogb.ogb03
               AND oga01 = rvbs01
               AND ogb03 = rvbs02
               AND rvbs13 = l_rvbs.rvbs13  
               AND rvbs09 = -1   
               AND ogaconf != 'X' 
               AND rvbs022 = l_rvbs.rvbs022   

            IF cl_null(l_rvbs06b) THEN
               LET l_rvbs06b = 0
            END IF

            LET l_rvbs.rvbs06 = l_rvbs06a - l_rvbs06b

            INSERT INTO rvbs_file VALUES(l_rvbs.*)
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"ins rvbs",SQLCA.sqlcode,1)                                                                                                                                              
               LET g_success='N'
               RETURN
            END IF
         END FOREACH
      END IF
      #-----END CHI-9C0024-----
   ELSE
      LET g_ogb.ogb01  = g_oga.oga01     #出貨單號
      LET g_ogb.ogb03  = g_oeb.oeb03     #項次
      LET g_ogb.ogb04  = g_oeb.oeb04     #產品編號
      LET g_ogb.ogb05  = g_oeb.oeb05     #銷售單位
      LET g_ogb.ogb05_fac = g_oeb.oeb05_fac
      LET g_ogb.ogb06  = g_oeb.oeb06     #品名規格
      LET g_ogb.ogb07  = g_oeb.oeb07     #額外品名編號
      LET g_ogb.ogb08  = g_oeb.oeb08     #出貨營運中心編號
      LET g_ogb.ogb09  = g_oeb.oeb09     #出貨倉庫編號
      LET g_ogb.ogb091 = g_oeb.oeb091    #出貨儲位編號
      LET g_ogb.ogb092 = g_oeb.oeb092    #出貨批號
      LET g_ogb.ogb1001= g_oeb.oeb1001  
      LET g_ogb.ogb1002= g_oeb.oeb1002
      LET g_ogb.ogb1003= g_oeb.oeb15
      LET g_ogb.ogb1004= g_oeb.oeb1004
      LET g_ogb.ogb1005= g_oeb.oeb1003
      LET g_ogb.ogb1006= g_oeb.oeb1006
      LET g_ogb.ogb11  = g_oeb.oeb11     #客戶產品編號
      LET g_ogb.ogb12  = g_oeb.oeb12     #實際出貨數量
      LET g_ogb.ogb13  = g_oeb.oeb13     #原幣單價
      LET g_ogb.ogb14  = g_oeb.oeb14     #原幣未稅金額 
      LET g_ogb.ogb14t = g_oeb.oeb14t    #原幣含稅金額
      LET g_ogb.ogb31  = g_oga.oga16     #訂單單號
      LET g_ogb.ogb32  = g_ogb.ogb03     #訂單項次
      LET g_ogb.ogb908 = g_oeb.oeb908    #手冊編號
      LET g_ogb.ogb910 = g_oeb.oeb910
      LET g_ogb.ogb911 = g_oeb.oeb911
      LET g_ogb.ogb912 = g_oeb.oeb912
      LET g_ogb.ogb913 = g_oeb.oeb913
      LET g_ogb.ogb914 = g_oeb.oeb914
      LET g_ogb.ogb915 = g_oeb.oeb915
      LET g_ogb.ogb916 = g_oeb.oeb916
      LET g_ogb.ogb917 = g_oeb.oeb917
      LET g_ogb.ogb19  = g_oeb.oeb906
      LET g_ogb.ogb17  = 'N'  #CHI-9C0024 
#No.TQC-640088
#     IF tm.type = '1' THEN
      LET g_ogb.ogb1007= g_oeb.oeb1007
      LET g_ogb.ogb1008= g_oeb.oeb1008
      LET g_ogb.ogb1009= g_oeb.oeb1009
      LET g_ogb.ogb1010= g_oeb.oeb1010
      LET g_ogb.ogb1011= g_oeb.oeb1011                
      LET g_ogb.ogb1012= g_oeb.oeb1012                
#     END IF
   END IF
   #LET g_ogb.ogb17  = 'N'             #多倉儲批出貨否   #CHI-9C0024
   LET g_ogb.ogb60  = 0               #已開發票數量
   LET g_ogb.ogb63  = 0               #銷退數量
   LET g_ogb.ogb64  = 0               #銷退數量 (不需換貨出貨)
   LET g_ogb.ogb930 = g_oeb.oeb930    #FUN-680006
   LET g_ogb.ogb1014   = 'N'                 #保稅放行否  #FUN-6B0044
   IF cl_null(g_ogb.ogb091) THEN LET g_ogb.ogb091 = ' ' END IF  #出貨儲位編號
   IF cl_null(g_ogb.ogb092) THEN LET g_ogb.ogb092 = ' ' END IF  #出貨批號
   #No.FUN-AB0067--begin    
   IF NOT s_chk_ware(g_ogb.ogb09) THEN
      LET g_success='N'
      RETURN 
   END IF 
   #No.FUN-AB0067--end
   IF g_ogb.ogb1005 = '1' THEN        #出貨
      #庫存明細單位由廠/倉/儲/批自動得出
      SELECT img09  INTO g_ogb.ogb15 
        FROM img_file
       WHERE img01 = g_ogb.ogb04 
         AND img02 = g_ogb.ogb09 
         AND img03 = g_ogb.ogb091
         AND img04 = g_ogb.ogb092
      CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,g_ogb.ogb15) 
         RETURNING l_flag,g_ogb.ogb15_fac
      IF l_flag > 0 THEN 
         LET g_ogb.ogb15_fac = 1 
      END IF
      #銷售/庫存匯總單位換算率
      SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01 = g_ogb.ogb04
      CALL s_umfchk(g_ogb.ogb04,g_ogb.ogb05,l_ima25)
         RETURNING l_flag,g_ogb.ogb05_fac
      IF l_flag > 0 THEN 
         LET g_ogb.ogb05_fac = 1
      END IF
      LET g_ogb.ogb16 = g_ogb.ogb12 * g_ogb.ogb15_fac  #數量
      LET g_ogb.ogb16 = s_digqty(g_ogb.ogb16,g_ogb.ogb15)    #FUN-910088--add--
      LET g_ogb.ogb18 = g_ogb.ogb12                    #預計出貨數量  
      #更新出貨單頭檔
      LET g_oga.oga50  = g_oga.oga50 + g_ogb.ogb14     #原幣出貨金額       #MOD-6B0132 mark #MOD-B30060 remark 
      LET g_oga.oga51  = g_oga.oga51 + g_ogb.ogb14t    #原幣出貨金額(含稅) #MOD-6B0132 mark #MOD-B30060 remark
      LET g_oga.oga1008= g_oga.oga1008 + g_ogb.ogb14t
   ELSE
#     IF tm.type = '1' THEN   #No.TQC-640088
      LET g_oga.oga1006= g_oga.oga1006 + g_ogb.ogb14
      LET g_oga.oga1007= g_oga.oga1007 + g_ogb.ogb14t
#     END IF
   END IF
   IF cl_null(g_ogb.ogb18) THEN
      LET g_ogb.ogb18 = 0
   END IF
   IF cl_null(g_ogb.ogb16) THEN
      LET g_ogb.ogb16 = 0
   END IF
   IF cl_null(g_ogb.ogb15) THEN
      LET g_ogb.ogb15 = g_ogb.ogb05 
      LET g_ogb.ogb16 = s_digqty(g_ogb.ogb16,g_ogb.ogb15)    #FUN-910088--add--
   END IF
   IF cl_null(g_ogb.ogb15_fac) THEN
      LET g_ogb.ogb15_fac = 1 
   END IF
#No.FUN-870007-start-
   IF cl_null(g_ogb.ogb44) THEN
      LET g_ogb.ogb44='1'
   END IF
   IF cl_null(g_ogb.ogb47) THEN
      LET g_ogb.ogb47=0
   END IF
   IF cl_null(g_ogb.ogb37) OR g_ogb.ogb37=0 THEN    #FUN-AB0061           
      LET g_ogb.ogb37=g_ogb.ogb13                   #FUN-AB0061           
   END IF                               #FUN-AB0061 
#No.FUN-870007--end--
   LET g_ogb.ogbplant = g_plant #FUN-980009
   LET g_ogb.ogblegal = g_legal #FUN-980009
  #FUN-AC0055 mark ---------------------begin-----------------------
  ##FUN-AB0096 -----------------add start-----------
  # IF cl_null(g_ogb.ogb50) THEN
  #    LET g_ogb.ogb50 = '1'
  # END IF
  ##FUN-AB0096 -----------------add end--------------
  #FUN-AC0055 mark ----------------------end------------------------
  #FUN-C50097 ADD BEGIN-----
  IF cl_null(g_ogb.ogb50) THEN 
    LET g_ogb.ogb50 = 0
  END IF 
  IF cl_null(g_ogb.ogb51) THEN 
    LET g_ogb.ogb51 = 0
  END IF 
  IF cl_null(g_ogb.ogb52) THEN 
    LET g_ogb.ogb52 = 0
  END IF
  IF cl_null(g_ogb.ogb53) THEN 
    LET g_ogb.ogb53 = 0
  END IF 
  IF cl_null(g_ogb.ogb54) THEN 
    LET g_ogb.ogb54 = 0
  END IF 
  IF cl_null(g_ogb.ogb55) THEN 
    LET g_ogb.ogb55 = 0
  END IF                                        
  #FUN-C50097 ADD END-------   
   #FUN-CB0087--add--str--
   IF g_aza.aza115 = 'Y' AND tm.type MATCHES '[13]' THEN
      CALL s_reason_code(g_ogb.ogb01,g_ogb.ogb31,'',g_ogb.ogb04,g_ogb.ogb09,g_oga.oga14,g_oga.oga15) RETURNING g_ogb.ogb1001
      IF cl_null(g_ogb.ogb1001) THEN
         CALL cl_err(g_ogb.ogb1001,'aim-425',1)
         LET g_success="N"
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--end--
   INSERT INTO ogb_file VALUES(g_ogb.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p201_ins_ogb():',SQLCA.sqlcode,1)  #No.FUN-660104 MARK
#     CALL cl_err3("ins","ogb_file",g_ogb.ogb01,g_ogb.ogb03,SQLCA.sqlcode,"","p201_ins_ogb():",1)  #No.FUN-660104  #NO. FUN-710033
      CALL s_errmsg('','',"p201_ins_ogb():",SQLCA.sqlcode,1)  #NO. FUN-710033                                                                                                                                            
      LET g_success = 'N'
      RETURN
   #No.FUN-7B0018 080304 add --begin
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ogbi.* TO NULL
         LET l_ogbi.ogbi01 = g_ogb.ogb01
         LET l_ogbi.ogbi03 = g_ogb.ogb03
         IF NOT s_ins_ogbi(l_ogbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   #No.FUN-7B0018 080304 add --end  
   END IF
END FUNCTION
 
FUNCTION p201_upd_oga()
 
   UPDATE oga_file SET oga50   = g_oga.oga50,
                       oga51   = g_oga.oga51,
                       oga1006 = g_oga.oga1006,
                       oga1007 = g_oga.oga1007,
                       oga1008 = g_oga.oga1008
                 WHERE oga01   = g_oga.oga01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('p201_upd_oga():',SQLCA.sqlcode,1)   #No.FUN-660104 MARK
#     CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","p201_upd_oga():",1)  #No.FUN-660104 #NO. FUN-710033
      CALL s_errmsg('','',"p201_upd_oga():",SQLCA.sqlcode,1)   #NO. FUN-710033 
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
