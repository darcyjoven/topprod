# Prog. Version..: '5.30.06-13.03.19(00008)'     #
#
# Program name...: s_add_img.4gl
# Descriptions...: 新增倉庫庫存明細檔(img_file)
# Date & Author..: 03/06/07 By Apple
# Usage..........: CALL s_add_img(p_img01,p_img02,p_img03,p_img04,p_img05,
#                                 p_img06,p_date) 
# Input Parameter:  p_img01   料號 
#                   p_img02   倉庫 
#                   p_img03   儲位 
#                   p_img04   批號 
#                   p_img05   參考號碼 
#                   p_img06   序號
#                   p_date    單據日期
# Modify.........: No.FUN-5A0018 05/10/12 By Sarah 增加select imd14,imd15 ,ime10,ime11 default img27,img28
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-920273 09/02/20 By claire 最後盤點日應回寫單據日期
# Modify.........: No.FUN-870007 09/08/21 By Zhangyajun img_file/imgplant,imglegal賦值
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.FUN-A90049 10/10/11 By huangtao 增加料號參數的判斷
# Modify.........: No.FUN-B10016 11/01/13 By Lilan 由Service呼叫時,控制不開窗
# Modify.........: No:CHI-C50010 12/06/01 By ck2yuan 調撥時,有效日期應拿原本調撥前的有效日期
# Modify.........: No:CHI-C80007 13/03/13 By Alberti 調撥時,先拿撥出倉的呆滯日前,等撥入在s_tlf再依單別決定是否更新呆滯日期
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
DEFINE   g_cnt           LIKE type_file.num10     	#No.FUN-680147 INTEGER
DEFINE   g_i             LIKE type_file.num5            #count/index for any purpose 	#No.FUN-680147 SMALLINT
DEFINE   g_redate        LIKE type_file.dat             #CHI-C50010 add
DEFINE   g_redate_f      LIKE type_file.chr1            #CHI-C50010 add
DEFINE   g_idledate      LIKE type_file.dat             #CHI-C80007 add
DEFINE   g_idledate_f    LIKE type_file.chr1            #CHI-C80007 add

FUNCTION s_add_img(p_img01,p_img02,p_img03,p_img04,p_img05,p_img06,p_date)
   DEFINE p_img01      LIKE img_file.img01
   DEFINE p_img02      LIKE img_file.img02
   DEFINE p_img03      LIKE img_file.img03
   DEFINE p_img04      LIKE img_file.img04
   DEFINE p_img05      LIKE img_file.img05
   DEFINE p_img06      LIKE img_file.img06
   DEFINE p_date       LIKE type_file.dat           	#No.FUN-680147 DATE
   DEFINE l_img        RECORD LIKE img_file.*
   DEFINE l_img09      LIKE img_file.img09
   DEFINE l_ima71      LIKE ima_file.ima71
   DEFINE l_gfe02      LIKE gfe_file.gfe02
   DEFINE l_row,l_col       LIKE type_file.num5   	#No.FUN-680147 SMALLINT
 
   INITIALIZE l_img.* TO NULL
   LET l_img.img01=p_img01              #料號
   LET l_img.img02=p_img02              #倉庫
   LET l_img.img03=p_img03              #儲位
   LET l_img.img04=p_img04              #批號
   LET l_img.img05=p_img05              #參考號碼
   LET l_img.img06=p_img06              #序號
  
#FUN-A90049 -------------start------------------------------------   
    IF s_joint_venture( p_img01,g_plant) OR NOT s_internal_item( p_img01,g_plant ) THEN
        RETURN
    END IF
#FUN-A90049 --------------end-------------------------------------
   # 檢查是否有相對應的倉庫/儲位資料存在,若無則自動新增一筆資料
   CALL s_locchk(l_img.img01,l_img.img02,l_img.img03) RETURNING g_i,l_img.img26
   IF g_i = 0 THEN LET g_errno='N' RETURN END IF
 
   SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
          WHERE ima01=l_img.img01
   IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
   LET l_img.img09 = l_img09
   LET l_img.img10=0
   LET l_img.img17=p_date      
   LET l_img.img13=null                      #No.7304
   IF l_ima71 =0
      THEN LET l_img.img18=g_lastdat
      ELSE LET l_img.img13=p_date            #No.7304
           LET l_img.img18=p_date +l_ima71
   END IF
  #CHI-C50010 str add-----              
   IF g_redate_f = 'Y'  THEN            
      LET l_img.img18 = g_redate        
   END IF
  #CHI-C50010 end add-----  
   SELECT ime04,ime05,ime06,ime07,ime09
         ,ime10,ime11                  #FUN-5A0018
     INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26
         ,l_img.img27,l_img.img28      #FUN-5A0018
     FROM ime_file
    WHERE ime01 = p_img02 AND ime02 = p_img03
          AND imeacti = 'Y'   #FUN-D40103
   IF SQLCA.sqlcode THEN 
      SELECT imd10,imd11,imd12,imd13,imd08
            ,imd14,imd15               #FUN-5A0018
        INTO l_img.img22, l_img.img23, l_img.img24, l_img.img25,l_img.img26
            ,l_img.img27,l_img.img28   #FUN-5A0018
        FROM imd_file WHERE imd01=l_img.img02
      IF SQLCA.SQLCODE THEN 
         LET l_img.img22 = 'S'  LET l_img.img23 = 'Y'
         LET l_img.img24 = 'Y'  LET l_img.img25 = 'N'
      END IF
   END IF
   LET l_img.img20=1         LET l_img.img21=1
   LET l_img.img30=0         LET l_img.img31=0
   LET l_img.img32=0         LET l_img.img33=0
   LET l_img.img34=1         LET l_img.img37=p_date  
  #CHI-C80007 str add----
   IF g_idledate_f = 'Y' THEN
      LET l_img.img37 = g_idledate
   END IF
  #CHI-C80007 end add----
   
   LET l_img.img14=p_date    #MOD-920273 add
   
   LET g_errno=' '

   IF g_sma.sma892[2,2]='Y' THEN
       IF g_prog <> 'aws_ttsrv2' THEN #FUN-B10016 add if 判斷
           LET l_row = 8  LET l_col = 29
           OPEN WINDOW s_add_img_w AT l_row,l_col WITH FORM "sub/42f/s_add_img"
           ATTRIBUTE(STYLE=g_win_style)
           CALL cl_ui_locale("s_add_img")
          
           DISPLAY l_img09 TO ima25
           DISPLAY l_ima71 TO ima71  #No.7304
           DISPLAY BY NAME l_img.img09, l_img.img21,
                           l_img.img26, l_img.img13, l_img.img18,   #No.7304
                           l_img.img19, l_img.img36,
                           l_img.img27, l_img.img28, l_img.img35
          #INPUT BY NAME l_img.img09, l_img.img21,
           INPUT BY NAME l_img.img09, 
                         l_img.img26, l_img.img13, l_img.img18,     #No.7304
                         l_img.img19, l_img.img36,
                         l_img.img27, l_img.img28, l_img.img35
              WITHOUT DEFAULTS
          
              AFTER FIELD img09
                IF cl_null(l_img.img09) THEN NEXT FIELD img09 END IF
                SELECT gfe02 INTO l_gfe02 FROM gfe_file 
                             WHERE gfe01=l_img.img09 AND gfeacti = 'Y'
                IF SQLCA.sqlcode THEN 
                #    CALL cl_err(l_img.img09,'aoo-012',0) NEXT FIELD img09  #FUN-670091
                CALL cl_err3("sel","gfe_file",l_img.img09,"",SQLCA.sqlcode,"","",0) NEXT FIELD img09 #FUN-670091
                END IF
                IF l_img.img09=l_img09 THEN
                   LET l_img.img21 = 1
                ELSE
                   CALL s_umfchk(l_img.img01,l_img.img09,l_img09)
                              RETURNING g_cnt,l_img.img21
                   IF g_cnt = 1 THEN 
                        CALL cl_err('','mfg3075',0)
                        NEXT FIELD img09
                    END IF
                 END IF
                 DISPLAY BY NAME l_img.img21
             #start FUN-5A0018 remark
             #AFTER FIELD img21
             #   IF cl_null(l_img.img21) THEN NEXT FIELD img21 END IF
             #   IF l_img.img21=0 THEN NEXT FIELD img21 END IF
             #end FUN-5A0018 remark
          
              AFTER FIELD img13               #No.7304
                 IF l_ima71 > 0 THEN
                    LET l_img.img18=l_img.img13+l_ima71
                    DISPLAY BY NAME l_img.img18
                 END IF
                
              AFTER FIELD img18              #No.7304
                 IF cl_null(l_img.img18) THEN NEXT FIELD img18 END IF
                 IF l_ima71 = 0 THEN LET l_img.img18=g_lastdat END IF
                 DISPLAY BY NAME l_img.img18
          
              AFTER FIELD img35            #bugno:7255
                 IF NOT cl_null(l_img.img35) THEN
                    SELECT * FROM pja_file WHERE pja01=l_img.img35 AND pjaacti = 'Y'
                                             AND pjaclose = 'N'    #No.FUN-960038
                    IF STATUS THEN
                       #CALL cl_err(l_img.img35,'apj-005',0) #FUN-670091
                       CALL cl_err3("sel","pja_file",l_img.img35,"",STATUS,"","",0) #FUN-670091
                       NEXT FIELD img35
                    END IF
                 END IF
          
              ON ACTION controlp 
                 CASE 
                    WHEN INFIELD (img35)
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_pja"
                         LET g_qryparam.default1 = l_img.img35
                         CALL cl_create_qry() RETURNING l_img.img35
                         CALL FGL_DIALOG_SETBUFFER( l_img.img35 )
                         DISPLAY BY NAME l_img.img35
                         NEXT FIELD img35 
                    OTHERWISE EXIT CASE
                 END CASE
          
              AFTER INPUT
                 IF l_ima71 = 0 THEN LET l_img.img18=g_lastdat END IF    #No.7304
                 DISPLAY BY NAME l_img.img18                             #No.7304
          
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
           
           END INPUT
          
           CLOSE WINDOW s_add_img_w
           IF INT_FLAG THEN LET INT_FLAG=0 LET g_errno='N' RETURN END IF
       END IF #FUN-B10016 add 
   END IF
   IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
   IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
   IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
   LET l_img.imgplant = g_plant #No.FUN-870007
   LET l_img.imglegal = g_legal #No.FUN-870007
 
   INSERT INTO img_file VALUES (l_img.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      #CALL cl_err('ins img: ',SQLCA.SQLCODE,1)  #FUN-670091
      CALL cl_err3("ins","img_file","","",SQLCA.SQLCODE,"","",0) #FUN-670091
      LET g_errno='N' 
   END IF
END FUNCTION
#CHI-C50010 str add-----
FUNCTION s_date_record(p_date,p_flag)
   DEFINE p_date       LIKE type_file.dat
   DEFINE p_flag       LIKE type_file.chr1


   IF p_flag = 'Y' THEN
     LET g_redate_f = 'Y'
     LET g_redate = p_date
   END IF

END FUNCTION
#CHI-C50010 end add-----

#CHI-C80007 str add-----
FUNCTION s_idledate_record(p_date)
   DEFINE p_date       LIKE type_file.dat

     LET g_idledate_f = 'Y'
     LET g_idledate = p_date

END FUNCTION
#CHI-C80007 end add-----
