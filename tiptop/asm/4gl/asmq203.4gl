# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asmq203.4gl
# Descriptions...: 單據查詢(雙單位)
# Date & Author..: 05/04/13 By ice
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VAR CHAR-> CHAR
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-650124 06/05/26 By Elva 查詢顯示異常
# Modify.........: No.FUN-670051 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-920034 09/02/13 By alex 調整為STRING用法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   tm RECORD
         wc            STRING    #TQC-920034
      END RECORD,
   g_tlff_tlff218        LIKE abh_file.abh11, #No.FUN-690010 VARCHAR(30),#TQC-5A0134 VAR CHAR-->CHAR                  #第二單位Rowid的內容
   g_tlff_tlff025t       LIKE tlff_file.tlff025,       #異動后庫存數量單位
   g_tlff_tlff035t       LIKE tlff_file.tlff035,       #異動后庫存數量單位
   g_tlff_tlff10t        LIKE tlff_file.tlff10,        #異動數量
   g_tlff_tlff11t        LIKE tlff_file.tlff11,        #異動數量單位
   g_tlff_tlff12t        LIKE tlff_file.tlff12,        #異動數量單位與異動目的數量單位轉換率
   g_tlff_tlff60t        LIKE tlff_file.tlff60,        #異動單據單位對庫存單位(ima_file)之換算率
   g_tlff_1     RECORD     LIKE tlff_file.*,             #異動記錄檔 
   g_ima02             	 LIKE ima_file.ima02,          #品名
   g_ima021		 LIKE ima_file.ima021,         #規格
   g_azf03		 LIKE azf_file.azf03,          #說明內容
   g_smydesc		 LIKE smy_file.smydesc,        #單據名稱
   g_wc,g_sql	         STRING,                 #No.FUN-580092 HCN
   g_argv1		 LIKE tlff_file.tlff01,  #異動料件編號
   g_argv2	         LIKE tlff_file.tlff06,  #No.FUN-690010 VARCHAR(10), #TQC-5A0134 VAR CHAR-->CHAR	               # Begin date 不可為空白
   g_argv3	         LIKE tlff_file.tlff06,  #No.FUN-690010 VARCHAR(10), #TQC-5A0134 VAR CHAR-->CHAR	               # End   date 不可為空白
   g_argv4	         LIKE tlff_file.tlff902, #No.FUN-690010 VARCHAR(10), #TQC-5A0134 VAR CHAR-->CHAR	               # Warehouse    可為空白
   g_argv5	         LIKE tlff_file.tlff903, #No.FUN-690010 VARCHAR(10), #TQC-5A0134 VAR CHAR-->CHAR	               # Location     可為空白
   g_argv6	         LIKE tlff_file.tlff904, #No.FUN-690010 VARCHAR(24), #TQC-5A0134 VAR CHAR-->CHAR	               # Lot no       可為空白
   g_argv7	         LIKE img_file.img09     # Unit         可為空白
DEFINE g_chr             LIKE type_file.chr1     #TQC-5A0134 VAR CHAR-->CHAR                    #緩存器  #No.FUN-690010 VARCHAR(1)
DEFINE g_cnt             LIKE type_file.num10    #計算選取筆數用  #No.FUN-690010 INTEGER
DEFINE g_msg             LIKE ze_file.ze03       #TQC-5A0134 VAR CHAR-->CHAR                   #錯誤訊息傳遞用  #No.FUN-690010 VARCHAR(72)
DEFINE g_row_count       LIKE type_file.num10    #總筆數計算  #No.FUN-690010 INTEGER
DEFINE g_curs_index      LIKE type_file.num10    #計算筆數給是否隱藏TOOLBAR按鈕用  #No.FUN-690010 INTEGER
DEFINE g_jump            LIKE type_file.num10    #查詢指定筆數  #No.FUN-690010 INTEGER
DEFINE g_no_ask          LIKE type_file.num5     #是否開啟指定筆窗口  #No.FUN-690010 SMALLINT
DEFINE l_i               LIKE type_file.num5     #No.FUN-690010 SMALLINT
                                                 
MAIN                                             
   OPTIONS                     
        INPUT NO WRAP
   DEFER INTERRUPT                   
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
   LET g_argv3=ARG_VAL(3)
   LET g_argv4=ARG_VAL(4)
   LET g_argv5=ARG_VAL(5)
   LET g_argv6=ARG_VAL(6)
   LET g_argv7=ARG_VAL(7)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
  
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0089
 
   OPEN WINDOW asmq203_w WITH FORM "asm/42f/asmq203" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
   CALL q203_def_form()   #FUN-610006
 
   IF NOT cl_null(g_argv1) THEN CALL q203_q() END IF
   LET g_action_choice=""
 
   CALL q203_menu()
 
   CLOSE WINDOW q203_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0089
 
END MAIN
 
FUNCTION q203_cs()
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-690010 SMALLINT
   DEFINE l_tlff    LIKE type_file.num5    #No.FUN-690010 SMALLINT   # flag for CONSTRUCT
   DEFINE l_tlfft   LIKE type_file.num5    #No.FUN-690010 SMALLINT   # flag for CONSTRUCT
   DEFINE l_wc      STRING                 #TQC-920034
   DEFINE li_i      LIKE type_file.num5    #TQC-920034
 
   CLEAR FORM
 
   CALL cl_opmsg('q')
 
   INITIALIZE tm.* TO NULL	
   LET INT_FLAG = 0 
 
   IF NOT cl_null(g_argv1) THEN                        #初時查詢條件
      LET tm.wc = " tlff01='",g_argv1,"'"
      IF NOT cl_null(g_argv2) THEN 
         LET tm.wc = tm.wc CLIPPED," AND tlff06 >= '",g_argv2,"' "
      END IF 
      IF NOT cl_null(g_argv3) THEN 
         LET tm.wc = tm.wc CLIPPED," AND tlff06 <= '",g_argv2,"' "
      END IF 
      IF NOT cl_null(g_argv4) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlff902='",g_argv4,"'"
      END IF
      IF NOT cl_null(g_argv5) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlff903='",g_argv5,"'"
      END IF
      IF NOT cl_null(g_argv6) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlff904='",g_argv6,"'"
      END IF
      IF NOT cl_null(g_argv7) THEN
         LET tm.wc=tm.wc CLIPPED," AND tlff220='",g_argv7,"'"
      END IF
   ELSE
      WHILE TRUE
         INITIALIZE g_tlff_tlff218 TO NULL    #No.FUN-750051
         INITIALIZE g_ima02 TO NULL    #No.FUN-750051
         INITIALIZE g_ima021 TO NULL    #No.FUN-750051
         INITIALIZE g_azf03 TO NULL    #No.FUN-750051
         INITIALIZE g_smydesc TO NULL    #No.FUN-750051
         CONSTRUCT BY NAME tm.wc ON                    #取查詢條件
            tlff01,tlff06,tlff905,tlff906,tlff62,tlff13,
            tlff14,tlff19,tlff64,tlff930,tlff99,tlff901,tlff902,tlff903,  #FUN-670051
            tlff904,tlff907,tlff10,tlff11,tlff12,tlff60,tlff10t,tlff11t,
            tlff12t,tlff60t,tlff02,tlff020,tlff021,tlff022,tlff023,tlff025,
            tlff025t,tlff026,tlff027,tlff03,tlff030,tlff031,tlff032,tlff033,
            tlff035,tlff035t,tlff036,tlff037,tlff07,tlff09,tlff211,tlff212
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
            #FUN-670051...............begin         
            ON ACTION CONTROLP
               CASE
                 WHEN INFIELD(tlff01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_ima"
                   LET g_qryparam.state = "c"
                   LET g_qryparam.default1 = g_tlff.tlff01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO tlff01
                   NEXT FIELD tlff01
                   WHEN INFIELD(tlff930)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form  = "q_gem4"
                      LET g_qryparam.state = "c"   #多選
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO tlff930
                      NEXT FIELD tlff930
                OTHERWISE
                   EXIT CASE
            END CASE
            #FUN-670051...............begin         
 
            ON IDLE g_idle_seconds                     #空閑時的處理
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
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
         END CONSTRUCT
         LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
         IF INT_FLAG THEN RETURN END IF
         IF tm.wc != ' 1=1' THEN EXIT WHILE END IF     #未下查詢條件
         CALL cl_err('',9046,0) 
      END WHILE
 
      #對雙單位的查詢條件進行轉換處理
      LET l_wc = tm.wc           
      LET l_tlff = 0
      LET l_tlfft = 0
 
#     #TQC-920034
#     FOR l_i = 1 TO 296                             
         #主單位是否下了查詢條件
         IF l_wc.getIndexOf('tlff10t=',1)  OR l_wc.getIndexOf('tlff11t=',1) OR 
            l_wc.getIndexOf('tlff12t=',1)  OR l_wc.getIndexOf('tlff60t=',1) OR 
            l_wc.getIndexOf('tlff025t=',1) OR l_wc.getIndexOf('tlff035t=',1) THEN
#        IF l_wc[l_i,l_i+7] = 'tlff10t=' OR l_wc[l_i,l_i+7] = 'tlff11t=' OR 
#           l_wc[l_i,l_i+7] = 'tlff12t=' OR l_wc[l_i,l_i+7] = 'tlff60t=' OR 
#           l_wc[l_i,l_i+8] = 'tlff025t=' OR l_wc[l_i,l_i+8] = 'tlff035t=' THEN
            LET l_tlfft = 1
         END IF        
         #第二單位是否下了查詢條件
         IF l_wc.getIndexOf('tlff10=',1)  OR l_wc.getIndexOf('tlff11=',1) OR 
            l_wc.getIndexOf('tlff12=',1)  OR l_wc.getIndexOf('tlff60=',1) OR 
            l_wc.getIndexOf('tlff025=',1) OR l_wc.getIndexOf('tlff035=',1) THEN
#        IF l_wc[l_i,l_i+6] = 'tlff10=' OR l_wc[l_i,l_i+6] = 'tlff11=' OR 
#           l_wc[l_i,l_i+6] = 'tlff12=' OR l_wc[l_i,l_i+6] = 'tlff60=' OR 
#           l_wc[l_i,l_i+7] = 'tlff025=' OR l_wc[l_i,l_i+7] = 'tlff035=' THEN
            LET l_tlff = 1
         END IF  
#     END FOR
 
 
      IF (l_tlff+l_tlfft) >= 1 THEN      
         #當雙單位下了查詢條件時的附加條件
         IF l_tlff = 1 THEN
            LET  tm.wc = tm.wc CLIPPED, " AND tlff219 = 1 "
         END IF
         IF l_tlfft = 1 THEN
            LET  l_wc = l_wc CLIPPED, " AND tlff219 = 2 "
         END IF
      END IF
 
      #當雙單位下了查詢條件后的轉換處理,消除兩個查詢條件的相互影響
#     #TQC-920034
#     FOR l_i = 1 TO 296
         IF l_tlfft = 1 THEN
           #IF l_wc[l_i,l_i+6] = 'tlff10=' THEN
           #   LET  l_wc[l_i,l_i+6] = '\'1=1\'<>'
           #END IF
           #IF l_wc[l_i,l_i+7] = 'tlff10t=' THEN
           #   LET  l_wc[l_i,l_i+7] = 'tlff10 ='
           #END IF
            IF l_wc.getIndexOf("tlff10=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff10=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),
                          l_wc.subString(l_wc.getIndexOf("and",li_i+4)+3,l_wc.getLength())
            END IF
            IF l_wc.getIndexOf("tlff10t=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff10t=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),"tlff10=",
                          l_wc.subString(li_i + 8 ,l_wc.getLength())
            END IF
 
           #IF l_wc[l_i,l_i+6] = 'tlff11=' THEN
           #   LET  l_wc[l_i,l_i+6] = '\'1=1\'<>'
           #END IF
           #IF l_wc[l_i,l_i+6] = 'tlff11t' THEN
           #   LET  l_wc[l_i,l_i+6] = 'tlff11 '
           #END IF
            IF l_wc.getIndexOf("tlff11=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff11=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),
                          l_wc.subString(l_wc.getIndexOf("and",li_i+4)+3,l_wc.getLength())
            END IF
            IF l_wc.getIndexOf("tlff11t=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff11t=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),"tlff11=",
                          l_wc.subString(li_i + 8 ,l_wc.getLength())
            END IF
 
           #IF l_wc[l_i,l_i+6] = 'tlff12=' THEN
           #   LET  l_wc[l_i,l_i+6] = '\'1=1\'<>'
           #END IF
           #IF l_wc[l_i,l_i+6] = 'tlff12t' THEN
           #   LET  l_wc[l_i,l_i+6] = 'tlff12 ='
           #END IF
            IF l_wc.getIndexOf("tlff12=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff12=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),
                          l_wc.subString(l_wc.getIndexOf("and",li_i+4)+3,l_wc.getLength())
            END IF
            IF l_wc.getIndexOf("tlff12t=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff12t=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),"tlff12=",
                          l_wc.subString(li_i + 8 ,l_wc.getLength())
            END IF
 
           #IF l_wc[l_i,l_i+6] = 'tlff60=' THEN
           #   LET  l_wc[l_i,l_i+6] = '\'1=1\'<>'
           #END IF
           #IF l_wc[l_i,l_i+6] = 'tlff60t' THEN
           #   LET  l_wc[l_i,l_i+6] = 'tlff60 '
           #END IF
            IF l_wc.getIndexOf("tlff60=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff60=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),
                          l_wc.subString(l_wc.getIndexOf("and",li_i+4)+3,l_wc.getLength())
            END IF
            IF l_wc.getIndexOf("tlff60t=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff60t=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),"tlff60=",
                          l_wc.subString(li_i + 8 ,l_wc.getLength())
            END IF
 
           #IF l_wc[l_i,l_i+7] = 'tlff025=' THEN
           #   LET  l_wc[l_i,l_i+7] = '\'1=1\' <>'
           #END IF
           #IF l_wc[l_i,l_i+7] = 'tlff025t' THEN
           #   LET  l_wc[l_i,l_i+7] = 'tlff025 '
           #END IF
            IF l_wc.getIndexOf("tlff025=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff025=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),
                          l_wc.subString(l_wc.getIndexOf("and",li_i+4)+3,l_wc.getLength())
            END IF
            IF l_wc.getIndexOf("tlff025t=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff025t=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),"tlff025=",
                          l_wc.subString(li_i + 9 ,l_wc.getLength())
            END IF
 
           #IF l_wc[l_i,l_i+7] = 'tlff035=' THEN
           #   LET  l_wc[l_i,l_i+7] = '\'1=1\' <>'
           #END IF
           #IF l_wc[l_i,l_i+7] = 'tlff035t' THEN
           #   LET  l_wc[l_i,l_i+7] = 'tlff035 '
           #END IF
            IF l_wc.getIndexOf("tlff035=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff035=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),
                          l_wc.subString(l_wc.getIndexOf("and",li_i+4)+3,l_wc.getLength())
            END IF
            IF l_wc.getIndexOf("tlff035t=",1) THEN
               LET li_i = l_wc.getIndexOf("tlff035t=",1) 
               LET l_wc = l_wc.subString(1,li_i - 1),"tlff035=",
                          l_wc.subString(li_i + 9 ,l_wc.getLength())
            END IF
         END IF
 
 
#        #TQC-920034
         IF l_tlff =1 THEN
           #IF tm.wc[l_i,l_i+6] = 'tlff10t' THEN
           #   IF tm.wc[l_i,l_i+7] = 'tlff10t=' THEN
           #      LET  tm.wc[l_i,l_i+7] = '\'1=1\' <>'
           #   ELSE
           #      LET  tm.wc[l_i,l_i+6] = 'tlff10 '
           #   END IF
           #END IF
            IF tm.wc.getIndexOf("tlff10t",1) THEN
               LET li_i = tm.wc.getIndexOf("tlff10t",1)
               IF tm.wc.subString(li_i,li_i + 7) = "tlff10t" THEN
                  LET tm.wc = tm.wc.subString(1,li_i - 1),
                              tm.wc.subString(tm.wc.getIndexOf("and",li_i+4)+3,tm.wc.getLength())
               ELSE
                  LET tm.wc = tm.wc.subString(1,li_i - 1),"tlff10",
                              tm.wc.subString(li_i + 5,tm.wc.getLength())
               END IF
            END IF
 
           #IF tm.wc[l_i,l_i+6] = 'tlff11t' THEN
           #   IF tm.wc[l_i,l_i+7] = 'tlff11t=' THEN
           #      LET  tm.wc[l_i,l_i+7] = '\'1=1\' <>'
           #   ELSE
           #      LET  tm.wc[l_i,l_i+6] = 'tlff11 '
           #   END IF
           #END IF
            IF tm.wc.getIndexOf("tlff11t",1) THEN
               LET li_i = tm.wc.getIndexOf("tlff11t",1)
               IF tm.wc.subString(li_i,li_i + 7) = "tlff11t" THEN
                  LET tm.wc = tm.wc.subString(1,li_i - 1),
                              tm.wc.subString(tm.wc.getIndexOf("and",li_i+4)+3,tm.wc.getLength())
               ELSE
                  LET tm.wc = tm.wc.subString(1,li_i - 1),"tlff11",
                              tm.wc.subString(li_i + 5,tm.wc.getLength())
               END IF
            END IF
 
           #IF tm.wc[l_i,l_i+6] = 'tlff12t' THEN
           #   IF tm.wc[l_i,l_i+7] = 'tlff12t=' THEN
           #      LET  tm.wc[l_i,l_i+7] = '\'1=1\' <>'
           #   ELSE
           #      LET  tm.wc[l_i,l_i+6] = 'tlff12 '
           #   END IF
           #END IF
            IF tm.wc.getIndexOf("tlff12t",1) THEN
               LET li_i = tm.wc.getIndexOf("tlff12t",1)
               IF tm.wc.subString(li_i,li_i + 7) = "tlff12t" THEN
                  LET tm.wc = tm.wc.subString(1,li_i - 1),
                              tm.wc.subString(tm.wc.getIndexOf("and",li_i+4)+3,tm.wc.getLength())
               ELSE
                  LET tm.wc = tm.wc.subString(1,li_i - 1),"tlff12",
                              tm.wc.subString(li_i + 5,tm.wc.getLength())
               END IF
            END IF
 
           #IF tm.wc[l_i,l_i+6] = 'tlff60t' THEN
           #   IF tm.wc[l_i,l_i+7] = 'tlff60t=' THEN
           #      LET  tm.wc[l_i,l_i+7] = '\'1=1\' <>'
           #   ELSE
           #      LET  tm.wc[l_i,l_i+6] = 'tlff60 '
           #   END IF
           #END IF
            IF tm.wc.getIndexOf("tlff60t",1) THEN
               LET li_i = tm.wc.getIndexOf("tlff60t",1)
               IF tm.wc.subString(li_i,li_i + 7) = "tlff60t" THEN
                  LET tm.wc = tm.wc.subString(1,li_i - 1),
                              tm.wc.subString(tm.wc.getIndexOf("and",li_i+4)+3,tm.wc.getLength())
               ELSE
                  LET tm.wc = tm.wc.subString(1,li_i - 1),"tlff60",
                              tm.wc.subString(li_i + 5,tm.wc.getLength())
               END IF
            END IF
 
           #IF tm.wc[l_i,l_i+7] = 'tlff025t' THEN
           #   IF tm.wc[l_i,l_i+8] = 'tlff025t=' THEN
           #      LET  tm.wc[l_i,l_i+8] = '\'1=1\'  <>'
           #   ELSE
           #      LET  tm.wc[l_i,l_i+7] = 'tlff025 '
           #   END IF
           #END IF
            IF tm.wc.getIndexOf("tlff025t",1) THEN
               LET li_i = tm.wc.getIndexOf("tlff025t",1)
               IF tm.wc.subString(li_i,li_i + 8) = "tlff025t" THEN
                  LET tm.wc = tm.wc.subString(1,li_i - 1),
                              tm.wc.subString(tm.wc.getIndexOf("and",li_i+4)+3,tm.wc.getLength())
               ELSE
                  LET tm.wc = tm.wc.subString(1,li_i - 1),"tlff025",
                              tm.wc.subString(li_i + 6,tm.wc.getLength())
               END IF
            END IF
 
           #IF tm.wc[l_i,l_i+7] = 'tlff035t' THEN
           #   IF tm.wc[l_i,l_i+8] = 'tlff035t=' THEN
           #      LET  tm.wc[l_i,l_i+8] = '\'1=1\'  <>'
           #   ELSE
           #      LET  tm.wc[l_i,l_i+7] = 'tlff035 '
           #   END IF
           #END IF
            IF tm.wc.getIndexOf("tlff035t",1) THEN
               LET li_i = tm.wc.getIndexOf("tlff035t",1)
               IF tm.wc.subString(li_i,li_i + 8) = "tlff035t" THEN
                  LET tm.wc = tm.wc.subString(1,li_i - 1),
                              tm.wc.subString(tm.wc.getIndexOf("and",li_i+4)+3,tm.wc.getLength())
               ELSE
                  LET tm.wc = tm.wc.subString(1,li_i - 1),"tlff035",
                              tm.wc.subString(li_i + 6,tm.wc.getLength())
               END IF
            END IF
 
         END IF
#     END FOR
   END IF
 
   #當只有第二單位下了查詢條件時，歸為tm.wc條件
   IF (l_tlff = 0) AND (l_tlfft = 1) THEN
      LET tm.wc = l_wc
   END IF
 
   #組合SQL語句
   LET g_sql = " SELECT DISTINCT tlff218,ima02,ima021,azf03,smydesc ",
                 " FROM tlff_file,OUTER ima_file,",
                                " OUTER azf_file, OUTER smy_file",
                " WHERE ",tm.wc CLIPPED,
                  " AND ima_file.ima01 = tlff01",
                  " AND azf_file.azf01 = tlff14",
                  " AND azf_file.azf02 = '2' ",
                  " AND tlff905 like trim(smy_file.smyslip) || '-%' "
   IF (l_tlff+l_tlfft = 2) THEN
      #雙單位同時存在時組SQL
      LET g_sql = g_sql CLIPPED, 
                  " AND tlff218 IN \(   ",
                  " SELECT DISTINCT tlff218  ",
                  " FROM tlff_file  ",
                  " WHERE ",l_wc CLIPPED, 
                  " \) "
   END IF
   PREPARE q203_prepare FROM g_sql
   IF STATUS THEN CALL cl_err('q203_prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   DECLARE q203_cs SCROLL CURSOR FOR q203_prepare
 
   #筆數顯示
   LET g_sql = " SELECT COUNT(UNIQUE tlff218) FROM tlff_file ",
               "  WHERE ",tm.wc CLIPPED  
   IF (l_tlff+l_tlfft) = 2  THEN
      #雙單位同時存在時計算筆數的SQL
      LET g_sql = g_sql CLIPPED,
                  " AND tlff218 IN \(   ",
                  " SELECT DISTINCT tlff218  ",
                  " FROM tlff_file  ",
                  " WHERE ",l_wc CLIPPED, 
                  " \) "
   END IF
   PREPARE q203_pp FROM g_sql
   DECLARE q203_cnt CURSOR FOR q203_pp
END FUNCTION
 
FUNCTION q203_menu()
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      ON ACTION query 
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL q203_q()
         END IF
      ON ACTION next 
         CALL q203_fetch('N')
      ON ACTION previous 
         CALL q203_fetch('P')
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL q203_def_form()   #FUN-610006
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON ACTION jump
         CALL q203_fetch('/')
      ON ACTION first
         CALL q203_fetch('F')
      ON ACTION last
         CALL q203_fetch('L')
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      ON ACTION about       
         CALL cl_about()   
      ON ACTION controlg  
         CALL cl_cmdask()
         LET g_action_choice = "exit"
         CONTINUE MENU
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
END FUNCTION
 
FUNCTION q203_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   CALL cl_opmsg('q')
   DISPLAY ' ' TO FORMONLY.cnt  
   CALL q203_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   OPEN q203_cs   
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,0)
      ELSE
         OPEN q203_cnt
         FETCH q203_cnt INTO g_row_count
         DISPLAY g_row_count TO cnt 
         CALL q203_fetch('F')                  # 讀出TEMP第一筆並顯示
      END IF
END FUNCTION
 
FUNCTION q203_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #TQC-5A0134 VAR CHAR-->CHAR               #處理方式  #No.FUN-690010 VARCHAR(1)
    l_cnt           LIKE type_file.num10,  #No.FUN-690010  INTEGER,
    l_tlff219       LIKE type_file.num10  #No.FUN-690010INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q203_cs INTO g_tlff_tlff218,g_ima02,g_ima021,g_azf03,g_smydesc
        WHEN 'P' FETCH PREVIOUS q203_cs INTO g_tlff_tlff218,g_ima02,g_ima021,g_azf03,g_smydesc
        WHEN 'F' FETCH FIRST    q203_cs INTO g_tlff_tlff218,g_ima02,g_ima021,g_azf03,g_smydesc
        WHEN 'L' FETCH LAST     q203_cs INTO g_tlff_tlff218,g_ima02,g_ima021,g_azf03,g_smydesc
        WHEN '/'
            IF (NOT g_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                  ON ACTION about      
                     CALL cl_about()  
                  ON ACTION help     
                     CALL cl_show_help() 
                  ON ACTION controlg     
                     CALL cl_cmdask()   
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q203_cs INTO g_tlff_tlff218,g_ima02,g_ima021,g_azf03,g_smydesc
            LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_tlff_1.tlff01,SQLCA.sqlcode,0) #TQC-650124
       INITIALIZE g_tlff_tlff218 TO NULL  #TQC-6B0105
       INITIALIZE g_ima02        TO NULL  #TQC-6B0105
       INITIALIZE g_ima021       TO NULL  #TQC-6B0105
       INITIALIZE g_azf03        TO NULL  #TQC-6B0105
       INITIALIZE g_smydesc      TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_tlff_1.* FROM tlff_file 
     WHERE tlff218 = g_tlff_tlff218 AND tlff219 = 1
    SELECT COUNT(tlff219) INTO l_cnt FROM tlff_file WHERE tlff218 = g_tlff_tlff218
    CASE l_cnt 
       WHEN "1"
          SELECT tlff219 INTO l_tlff219 FROM tlff_file WHERE tlff218 = g_tlff_tlff218
          IF l_tlff219 = '1' THEN
             LET g_tlff_tlff025t = ' '
             LET g_tlff_tlff035t = ' '
             LET g_tlff_tlff10t = ' '
             LET g_tlff_tlff11t = ' '
             LET g_tlff_tlff12t = ' '
             LET g_tlff_tlff60t = ' '
          ELSE 
             SELECT * INTO g_tlff_1.* FROM tlff_file 
              WHERE tlff218 = g_tlff_tlff218 AND tlff219 = 2
             #TQC-650124  --begin
             LET g_tlff_tlff025t = g_tlff_1.tlff025
             LET g_tlff_tlff035t = g_tlff_1.tlff035
             LET g_tlff_tlff10t = g_tlff_1.tlff10
             LET g_tlff_tlff11t = g_tlff_1.tlff11
             LET g_tlff_tlff12t = g_tlff_1.tlff12
             LET g_tlff_tlff60t = g_tlff_1.tlff60
             LET g_tlff_1.tlff025 = ''
             LET g_tlff_1.tlff035 = ''
             LET g_tlff_1.tlff10 = ''
             LET g_tlff_1.tlff11 = ''
             LET g_tlff_1.tlff12 = ''
             LET g_tlff_1.tlff60 = ''
             #TQC-650124  --end
          END IF   
       WHEN "2"
          SELECT tlff025,tlff035,tlff10,tlff11,tlff12,tlff60
            INTO g_tlff_tlff025t,g_tlff_tlff035t,g_tlff_tlff10t,g_tlff_tlff11t,
                 g_tlff_tlff12t,g_tlff_tlff60t
            FROM tlff_file 
           WHERE tlff218 = g_tlff_tlff218 AND tlff219 = '2'
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_tlff_1.tlff01,SQLCA.sqlcode,0) #TQC-650124
        RETURN
    END IF
    CALL q203_show()
END FUNCTION
 
FUNCTION q203_show()
   #TQC-650124  --begin
   DISPLAY BY NAME
      g_tlff_1.tlff01,g_ima02,g_ima021,g_tlff_1.tlff02,g_tlff_1.tlff03, 
      g_tlff_1.tlff06,g_tlff_1.tlff09,g_tlff_1.tlff07,g_tlff_1.tlff14, 
      g_azf03,g_tlff_1.tlff10,g_tlff_1.tlff11,g_tlff_1.tlff12,g_tlff_1.tlff60, 
      g_tlff_1.tlff64,g_tlff_1.tlff99,g_tlff_1.tlff15,g_tlff_1.tlff16, 
      g_tlff_1.tlff13,g_tlff_1.tlff901,g_tlff_1.tlff902,g_tlff_1.tlff903, 
      g_tlff_1.tlff904,g_tlff_1.tlff905,g_smydesc,g_tlff_1.tlff906, 
      g_tlff_1.tlff907,g_tlff_1.tlff62 ,g_tlff_1.tlff19,g_tlff_1.tlff020,
      g_tlff_1.tlff030,g_tlff_1.tlff021,g_tlff_1.tlff022,g_tlff_1.tlff031,
      g_tlff_1.tlff032,g_tlff_1.tlff023,g_tlff_1.tlff033,g_tlff_1.tlff025, 
      g_tlff_1.tlff035,g_tlff_1.tlff026, 
      g_tlff_1.tlff027,g_tlff_1.tlff036,g_tlff_1.tlff037,g_tlff_1.tlff21,
      g_tlff_1.tlff211,g_tlff_1.tlff212 
   #TQC-650124  --end
   DISPLAY g_tlff_tlff10t  TO FORMONLY.tlff10t
   DISPLAY g_tlff_tlff11t  TO FORMONLY.tlff11t
   DISPLAY g_tlff_tlff12t  TO FORMONLY.tlff12t
   DISPLAY g_tlff_tlff60t  TO FORMONLY.tlff60t
   DISPLAY g_tlff_tlff025t TO FORMONLY.tlff025t
   DISPLAY g_tlff_tlff035t TO FORMONLY.tlff035t
   CALL s_command(g_tlff_1.tlff13) RETURNING g_chr,g_msg #TQC-650124
   DISPLAY g_msg TO tlff13_desc
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
#-----FUN-610006---------
FUNCTION q203_def_form()
    IF g_sma.sma122 ='1' THEN                                                    
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff025",g_msg CLIPPED)                          
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff025t",g_msg CLIPPED)                          
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff035",g_msg CLIPPED)                          
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff035t",g_msg CLIPPED)                          
    END IF                                                                       
    IF g_sma.sma122 ='2' THEN                                                    
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff025",g_msg CLIPPED)                          
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff025t",g_msg CLIPPED)                          
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff035",g_msg CLIPPED)                          
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg                          
       CALL cl_set_comp_att_text("tlff035t",g_msg CLIPPED)                          
    END IF
END FUNCTION
#-----END FUN-610006-----
 
