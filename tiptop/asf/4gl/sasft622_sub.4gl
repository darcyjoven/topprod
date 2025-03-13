# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Program name...: sasft622sub_sub.4gl
# Description....: 提供sasft622.4gl使用的sub routine
# Date & Author..: 09/05/24 By Carrier (No.FUN-950021)
# Modify.........: No.CHI-950036 09/06/26 By jan ksc03-->ksd17
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.           09/10/21 By lilingyu r.2 fail    
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.FUN-9B0059 09/11/09 By wujie  5.2SQL转标准语法 
# Modify.........: No.MOD-A30193 10/03/30 By Summer 1.單身鍵入FQC單時,應帶出該筆FQC可入庫量
#                                                   2.請在確認段就控卡入庫量不可為0
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A40023 10/04/12 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A40022 10/10/25 By jan 當料件為批號控管,則批號必須輸入
# Modify.........: No.FUN-AB0054 10/11/12 By zhangll 倉庫營運中心權限控管審核段控管
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No.FUN-B50096 11/08/18 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No.FUN-BB0001 12/01/17 By pauline 新增rvv22,INSERT/UPDATE rvb22時,同時INSERT/UPDATE rvv22
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,t622sub_y_chk新增傳入參數
# Modify.........: No.TQC-C50236 12/05/29 By fengrui 確認還原時,不應影響 最近入庫日、最近出庫日、最近異動日、最近盤點日
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C60207 12/06/28 By lixh1 審核時控管廠商是否可用
# Modify.........: No.FUN-C70087 12/08/01 By bart 整批寫入img_file
# Modify.........: No:TQC-CA0028 12/10/11 By bart 離開程式前要drop temp table
# Modify.........: No:CHI-CB0041 12/11/15 By bart 修改TQC-CA0028問題
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No.FUN-D10094 13/01/12 By fengrui 倉庫單據理由碼改善,單身添加理由碼,还原FUN-CB0087修改
# Modify.........: No:FUN-D30024 13/03/12 By fengrui 負庫存依據imd23判斷
# Modify.........: No:FUN-D30065 13/03/20 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原

DATABASE ds
 
GLOBALS "../../config/top.global"

GLOBALS
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD  #No.FUN-610090         #NO.FUN-9B0016         
                          unit   LIKE ima_file.ima25,                           
                          fac    LIKE img_file.img21,                           
                          qty    LIKE img_file.img10                            
                       END RECORD     
#FUN-CC0095---begin
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
#FUN-CC0095---end                       
END GLOBALS 
 
#{
#作用:lock cursor
#回傳值:無
#}
FUNCTION t622sub_lock_cl()
   DEFINE l_forupd_sql STRING
   LET l_forupd_sql = "SELECT * FROM ksc_file WHERE ksc01 = ? FOR UPDATE"
   LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)

   DECLARE t622sub_cl CURSOR FROM l_forupd_sql
END FUNCTION
 
FUNCTION t622sub_y_chk(p_ksc01,p_action_choice) #CHI-C30118 add p_action_choice     
   DEFINE p_ksc01    LIKE ksc_file.ksc01
   DEFINE l_ksc      RECORD LIKE ksc_file.*
   DEFINE l_ksd      RECORD LIKE ksd_file.*
   DEFINE l_cnt      LIKE type_file.num10 
   DEFINE l_str      STRING
   DEFINE l_imaicd08 LIKE imaicd_file.imaicd08  
   DEFINE l_flag     LIKE type_file.num10       
   DEFINE l_rvbs06   LIKE rvbs_file.rvbs06      
   DEFINE l_date     LIKE type_file.dat    
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921   
   DEFINE l_img09    LIKE img_file.img09
   DEFINE l_sfb39    LIKE sfb_file.sfb39
   DEFINE l_i        LIKE type_file.num5
   DEFINE l_fac      LIKE ima_file.ima31_fac
#  DEFINE l_imaicd13 LIKE imaicd_file.imaicd13  #FUN-A40022 #FUN-B50096
   DEFINE l_ima159   LIKE ima_file.ima159       #FUN-B50096 
   DEFINE p_action_choice  STRING #CHI-C30118 add
   DEFINE l_gem01    LIKE gem_file.gem01        #TQC-C60207
   
   WHENEVER ERROR CONTINUE
   
   LET g_success='Y'
   
   SELECT * INTO l_ksc.* FROM ksc_file WHERE ksc01=p_ksc01  
   IF cl_null(l_ksc.ksc01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
   
   LET l_cnt=0  
   SELECT COUNT(*) INTO l_cnt FROM ksd_file WHERE ksd01 = l_ksc.ksc01
   IF l_cnt = 0 THEN
      CALL cl_err(l_ksc.ksc01,'mfg-009',0) 
      LET g_success='N' 
      RETURN
   END IF
   
   IF l_ksc.kscconf = 'Y' THEN
      LET g_success='N'
      CALL cl_err(l_ksc.ksc01,'9023',0)
      RETURN
   END IF
   
   IF l_ksc.kscconf = 'X' THEN
      LET g_success='N' 
      CALL cl_err(l_ksc.ksc01,'9024',0) 
      RETURN
   END IF

#CHI-C30118---add---START
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
   END IF
#CHI-C30118---add---END   
#CHI-C30107 ---------------- add ----------------- begin
   SELECT * INTO l_ksc.* FROM ksc_file WHERE ksc01=p_ksc01
   IF cl_null(l_ksc.ksc01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF

   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM ksd_file WHERE ksd01 = l_ksc.ksc01
   IF l_cnt = 0 THEN
      CALL cl_err(l_ksc.ksc01,'mfg-009',0)
      LET g_success='N'
      RETURN
   END IF

   IF l_ksc.kscconf = 'Y' THEN
      LET g_success='N'
      CALL cl_err(l_ksc.ksc01,'9023',0)
      RETURN
   END IF

   IF l_ksc.kscconf = 'X' THEN
      LET g_success='N'
      CALL cl_err(l_ksc.ksc01,'9024',0)
      RETURN
   END IF
#CHI-C30107 ---------------- add ----------------- end

#TQC-C60207 ----------------Begin------------------
   IF NOT cl_null(l_ksc.ksc04) THEN 
      SELECT gem01 INTO l_gem01 FROM gem_file
       WHERE gem01 = l_ksc.ksc04
         AND gemacti = 'Y'
      IF STATUS THEN 
         LET g_success='N'
         CALL cl_err(l_ksc.ksc04,'asf-683',0)
         RETURN
      END IF
   END IF 
#TQC-C60207 ----------------End--------------------
  
  #str MOD-A30193 add
  #Check 單身入庫量(ksd09)不可為0
   CALL s_showmsg_init()
   DECLARE t622sub_y_c CURSOR FOR
    SELECT * FROM ksd_file WHERE ksd01=g_ksc.ksc01 AND ksd09=0
   FOREACH t622sub_y_c INTO l_ksd.*
      LET g_success = 'N'
      CALL s_errmsg("ksd03",l_ksd.ksd03,"",'asf-660',1)
   END FOREACH
   CALL s_showmsg()
   IF g_success = 'N' THEN
      RETURN
   END IF
  #end MOD-A30193 add

 
   #Cehck 單身 料倉儲批是否存在 img_file
   DECLARE t622sub_y_chk_c CURSOR FOR SELECT * FROM ksd_file
                                       WHERE ksd01=l_ksc.ksc01
   FOREACH t622sub_y_chk_c INTO l_ksd.*
   
      #Add No.FUN-AB0054
      IF NOT s_chk_ware(l_ksd.ksd05) THEN  #检查仓库是否属于当前门店
         LET g_success='N'
         EXIT FOREACH
      END IF
      #End Add No.FUN-AB0054
      #-----No.FUN-860045 Begin-----
      SELECT ima918,ima921 INTO l_ima918,l_ima921 
        FROM ima_file
       WHERE ima01 = l_ksd.ksd04
         AND imaacti = "Y"
      
      IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = l_ksd.ksd01
            AND rvbs02 = l_ksd.ksd03
            AND rvbs09 = 1
            AND rvbs13 = 0
            
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
            
         SELECT img09 INTO l_img09 FROM img_file
          WHERE img01=l_ksd.ksd04
            AND img02=l_ksd.ksd05
            AND img03=l_ksd.ksd06
            AND img04=l_ksd.ksd07
 
         CALL s_umfchk(l_ksd.ksd04,l_ksd.ksd08,l_img09) 
             RETURNING l_i,l_fac
 
         IF l_i = 1 THEN LET l_fac = 1 END IF
 
         IF (l_ksd.ksd09 * l_fac) <> l_rvbs06 THEN
            LET g_success = "N"
            CALL cl_err(l_ksd.ksd04,"aim-011",1)
            EXIT FOREACH
         END IF
      END IF
      #-----No.FUN-860045 END-----
#FUN-C70087---begin 
#      LET l_cnt=0
# 
#      SELECT COUNT(*) INTO l_cnt FROM img_file WHERE img01=l_ksd.ksd04
#                                                 AND img02=l_ksd.ksd05
#                                                 AND img03=l_ksd.ksd06
#                                                 AND img04=l_ksd.ksd07
#      IF l_cnt=0 THEN
#         LET g_success='N'
#         LET l_str="Item ",l_ksd.ksd03,":"
#         CALL cl_err(l_str,'asf-507',1)
#         EXIT FOREACH
#      END IF
#FUN-C70087---end      
      #FUN-A40022--begin--add--------
#FUN-B50096 ----------Begin------------
#     IF s_industry('icd') THEN
#        LET l_imaicd13=''
#        SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
#         WHERE imaicd00 = l_ksd.ksd04
#        IF l_imaicd13 = 'Y' AND cl_null(l_ksd.ksd07) THEN
      LET l_ima159 = ''
      SELECT ima159 INTO l_ima159 FROM ima_file
       WHERE ima01 = l_ksd.ksd04
      IF l_ima159 = '1' AND cl_null(l_ksd.ksd07) THEN   
#FUN-B50096 ----------End--------------
         LET g_success = 'N'
         CALL cl_err(l_ksd.ksd04,'aim-034',1)
         EXIT FOREACH
      END IF
#     END IF    #FUN-B50096
      #FUN-A40022---end--add----------
      
      #No.MOD-890047--begin--
      CALL t622sub_check_ksd11(l_ksd.ksd11)
      IF NOT cl_null(g_errno) THEN 
         CALL cl_err(l_ksd.ksd11,g_errno,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF 
      #No.MOD-890047---end---      
      #FUN-D10094--add--str--
      IF g_aza.aza115='Y' AND cl_null(l_ksd.ksd36) THEN
         CALL cl_err('','aim-888',1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      #FUN-D10094--add--end--
 
   END FOREACH
      
   IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
#No.MOD-890047--begin--
#該函數的功能是判斷拆件式工單中的產品料號，單身會有相同料號的bom料號，
#是否有發料。若沒有發料給出警告
FUNCTION t622sub_check_ksd11(p_sfb01)
   DEFINE p_sfb01        LIKE sfb_file.sfb01
   DEFINE l_cnt          LIKE type_file.num5
   DEFINE l_sfb02        LIKE sfb_file.sfb02
   DEFINE l_sfb39        LIKE sfb_file.sfb39  
 
    LET l_cnt = 0
    LET g_errno = ''
    LET l_sfb02 = NULL 
    LET l_sfb39 = NULL
    SELECT sfb02,sfb39 INTO l_sfb02,l_sfb39 FROM sfb_file
     WHERE sfb01 = p_sfb01
    IF l_sfb02 <> '11' THEN 
       RETURN 
    END IF 
    IF l_sfb39 = '2' THEN RETURN END IF 
    SELECT COUNT(*) INTO l_cnt FROM sfa_file,sfb_file
     WHERE sfb01 = sfa01
       AND sfb05 = sfa03
       AND sfa06 > 0 
       AND sfb01 = p_sfb01
    IF l_cnt = 0 THEN 
       LET g_errno='asf-109'
    END IF 
 
END FUNCTION 
#No.MOD-890047---end---
 
FUNCTION t622sub_y_upd(p_ksc01,p_action_choice,p_inTransaction)
   DEFINE p_ksc01          LIKE ksc_file.ksc01
   DEFINE p_action_choice  STRING
   DEFINE p_inTransaction  LIKE type_file.num5 
   DEFINE l_ksc            RECORD LIKE ksc_file.*
 
   LET g_success = 'Y'
 
   #CHI-C30118---mark---START--移至y_chk最上方
   #IF NOT cl_null(p_action_choice) THEN  #FUN-840012    #carrier
   #   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
   #END IF
   #CHI-C30118---mark---END
   
   IF cl_null(p_ksc01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
 
   IF NOT p_inTransaction THEN   
      BEGIN WORK    #carrier
   END IF
 
   CALL t622sub_lock_cl() 
   OPEN t622sub_cl USING p_ksc01
   IF STATUS THEN
      CALL cl_err("OPEN t622sub_cl:", STATUS, 1)
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   FETCH t622sub_cl INTO l_ksc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ksc:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   CLOSE t622sub_cl
 
   UPDATE ksc_file SET kscconf = 'Y' WHERE ksc01=l_ksc.ksc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ksc_file",l_ksc.ksc01,"",SQLCA.sqlcode,"","upd kscconf",1) 
      LET g_success='N'
   END IF
 
    #--FUN-8C0081--start--
    IF g_success='Y' THEN
       LET l_ksc.kscconf = "Y"
       IF NOT p_inTransaction THEN COMMIT WORK END IF
       CALL cl_flow_notify(l_ksc.ksc01,'Y')
    ELSE
       LET l_ksc.kscconf = "N"
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
    END IF
    #--FUN-8C0081--end--
END FUNCTION
 
FUNCTION t622sub_refresh(p_ksc01)
  DEFINE p_ksc01 LIKE ksc_file.ksc01
  DEFINE l_ksc RECORD LIKE ksc_file.*
 
  SELECT * INTO l_ksc.* FROM ksc_file WHERE ksc01=p_ksc01
  RETURN l_ksc.*
END FUNCTION
 
FUNCTION t622sub_z(p_ksc01,p_action_choice,p_inTransaction)
   DEFINE p_ksc01          LIKE ksc_file.ksc01
   DEFINE p_action_choice  STRING
   DEFINE p_inTransaction  LIKE type_file.num5 
   DEFINE l_ksc            RECORD LIKE ksc_file.*
 
   LET g_success = 'Y'
 
   SELECT * INTO l_ksc.* FROM ksc_file WHERE ksc01=p_ksc01  
   IF cl_null(l_ksc.ksc01) THEN
      CALL cl_err('','-400',1)
      LET g_success='N'
      RETURN
   END IF
   
   IF l_ksc.kscconf = 'N' THEN
      LET g_success='N'
      CALL cl_err(l_ksc.ksc01,'9025',0)
      RETURN
   END IF
   
   IF l_ksc.kscconf = 'X' THEN
      LET g_success='N' 
      CALL cl_err(l_ksc.ksc01,'9024',0) 
      RETURN
   END IF   
   
   IF l_ksc.kscpost = 'Y' THEN
      LET g_success='N' 
      CALL cl_err(l_ksc.ksc01,'afa-101',0) 
      RETURN
   END IF   
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('axm-109') THEN LET g_success = 'N' RETURN END IF
   END IF
   
   IF NOT p_inTransaction THEN 
      BEGIN WORK    #carrier
   END IF
 
   CALL t622sub_lock_cl() #FUN-730012
   OPEN t622sub_cl USING l_ksc.ksc01
   IF STATUS THEN
      CALL cl_err("OPEN t622sub_cl:", STATUS, 1)
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      RETURN
   END IF
 
   FETCH t622sub_cl INTO l_ksc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ksc:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      RETURN
   END IF
   
   CLOSE t622sub_cl
 
   UPDATE ksc_file SET kscconf = 'N' WHERE ksc01=l_ksc.ksc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ksc_file",l_ksc.ksc01,"",SQLCA.sqlcode,"","upd kscconf",1) 
      LET g_success='N'
   END IF
 
    #--FUN-8C0081--start--
    IF g_success='Y' THEN
       LET l_ksc.kscconf = "N"
       IF NOT p_inTransaction THEN COMMIT WORK END IF
    ELSE
       LET l_ksc.kscconf = "Y"
       IF NOT p_inTransaction THEN ROLLBACK WORK END IF
    END IF
    #--FUN-8C0081--end--
END FUNCTION
 
 
#p_argv1 : #1.發料 2.退料 #TQC-890051
#p_inTransaction : IF p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#p_ask_post : IF p_ask_post=TRUE 會詢問"是否執行過帳"
FUNCTION t622sub_s(p_ksc01,p_argv,p_inTransaction,p_action_choice)
   DEFINE p_ksc01         LIKE ksc_file.ksc01
   DEFINE p_argv          LIKE type_file.chr1
   DEFINE p_inTransaction LIKE type_file.num5 
   DEFINE p_action_choice STRING   
   DEFINE l_ksc           RECORD LIKE ksc_file.*
   DEFINE l_cnt           LIKE type_file.num5 
   DEFINE l_yy            LIKE type_file.num5
   DEFINE l_mm            LIKE type_file.num5
   DEFINE l_ksc03         LIKE ksc_file.ksc03  
   DEFINE lj_result       LIKE type_file.chr1  #No.FUN-930108 存s_incchk()返回值
   DEFINE l_ksd           RECORD LIKE ksd_file.*
   DEFINE l_ksc02         LIKE ksc_file.ksc02
   #DEFINE l_img_table      STRING                 #FUN-C70087  #FUN-CC0095
   #DEFINE l_imgg_table     STRING                 #FUN-C70087  #FUN-CC0095
   DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
   DEFINE l_flag          LIKE type_file.chr1     #FUN-C70087
   DEFINE l_sql            STRING                 #FUN-C70087
 
   WHENEVER ERROR CONTINUE                #忽略一切錯誤  #FUN-740187
   #CALL s_padd_img_create() RETURNING l_img_table    #FUN-C70087 #FUN-CC0095
   #CALL s_padd_imgg_create() RETURNING l_imgg_table  #FUN-C70087 #FUN-CC0095
   LET g_success='Y' #FUN-740187
   
   IF s_shut(0) THEN 
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN 
   END IF
 
   SELECT * INTO l_ksc.* FROM ksc_file WHERE ksc01=p_ksc01
 
   IF l_ksc.ksc01 IS NULL THEN
      CALL cl_err('',-400,0)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   #FUN-660106...............begin
   IF l_ksc.kscconf = 'N' THEN
      CALL cl_err('','aba-100',1)
      LET g_success='N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
   #FUN-660106...............end
 
   #-->已扣帳
   IF l_ksc.kscpost = 'Y' THEN
      CALL cl_err('kscpost=Y','asf-812',1)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   IF l_ksc.kscconf = 'X' THEN  #FUN-660106
      CALL cl_err('','9024',1)
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   #-----No.FUN-930108--start-----
   DECLARE t622sub_s_c CURSOR FOR
     SELECT * FROM ksd_file WHERE ksd01=l_ksc.ksc01
   
   CALL s_showmsg_init()
 
   FOREACH t622sub_s_c INTO l_ksd.*
      IF cl_null(l_ksd.ksd04) THEN
         #LET g_success='N'
         CONTINUE FOREACH
      END IF
      CALL s_incchk(l_ksd.ksd05,l_ksd.ksd06,g_user)
           RETURNING  lj_result
      IF NOT lj_result THEN
         LET g_showmsg = l_ksd.ksd03,"/",l_ksd.ksd05,"/",l_ksd.ksd06,"/",g_user
         CALL s_errmsg('ksd03,ksd05,ksd06,inc03',g_showmsg,'','asf-888',1)
         LET g_success = 'N'                       #carrier add
         EXIT FOREACH
      END IF
   END FOREACH
   #-----No.FUN930108---end------
   CALL s_showmsg()
   IF g_success = 'N' THEN 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN 
   END IF
   
   #FUN-860069
   LET l_ksc02 = l_ksc.ksc02
 
   IF NOT cl_null(p_action_choice) THEN  #FUN-840012
      IF NOT cl_confirm('mfg0176') THEN 
         LET g_success='N'
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
         RETURN 
   END IF
   END IF
   
   IF NOT cl_null(g_action_choice) THEN  #FUN-840012 外部呼叫時
      DISPLAY BY NAME l_ksc.ksc02
      INPUT BY NAME l_ksc.ksc02 WITHOUT DEFAULTS
      
           AFTER FIELD ksc02
               IF NOT cl_null(l_ksc.ksc02) THEN
                  IF g_sma.sma53 IS NOT NULL AND l_ksc.ksc02 <= g_sma.sma53 THEN
                     CALL cl_err('','mfg9999',0) 
                     NEXT FIELD ksc02
                  END IF
                  CALL s_yp(l_ksc.ksc02) RETURNING l_yy,l_mm
                  IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                     CALL cl_err(l_yy,'mfg6090',0) 
                     NEXT FIELD ksc02
                  END IF
               END IF
               
           AFTER INPUT 
               IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  LET l_ksc.ksc02=l_ksc02
                  DISPLAY BY NAME l_ksc.ksc02
                  #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
                  #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
                  RETURN
               END IF
               IF NOT cl_null(l_ksc.ksc02) THEN
                  IF g_sma.sma53 IS NOT NULL AND l_ksc.ksc02 <= g_sma.sma53 THEN
                     CALL cl_err('','mfg9999',0) 
                     NEXT FIELD ksc02
                  END IF
                  CALL s_yp(l_ksc.ksc02) RETURNING l_yy,l_mm
                  IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                     CALL cl_err(l_yy,'mfg6090',0) 
                     NEXT FIELD ksc02
                  END IF
               ELSE
                  CONTINUE INPUT
               END IF
               
           ON ACTION CONTROLG 
              CALL cl_cmdask()
   
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
      END INPUT
   END IF
   #--
 
   IF g_sma.sma53 IS NOT NULL AND l_ksc.ksc02 <= g_sma.sma53 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg9999',0) 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
    #MOD-480061
   SELECT COUNT(*) INTO l_cnt FROM ksd_file WHERE ksd01=l_ksc.ksc01
   IF l_cnt=0 THEN
      CALL cl_err('','arm-034',0)
      LET g_success = 'N'
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
   #--
 
   CALL s_yp(l_ksc.ksc02) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      LET g_success = 'N'
      CALL cl_err(l_yy,'mfg6090',0) 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   IF NOT p_inTransaction THEN
      BEGIN WORK
   END IF

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t622_s_c2 CURSOR FOR SELECT * FROM ksd_file
     WHERE ksd01 = l_ksc.ksc01 

   FOREACH t622_s_c2 INTO l_ksd.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM img_file
       WHERE img01 = l_ksd.ksd04
         AND img02 = l_ksd.ksd05
         AND img03 = l_ksd.ksd06
         AND img04 = l_ksd.ksd07
       IF l_cnt = 0 THEN
          #CALL s_padd_img_data(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ksc.ksc01,l_ksd.ksd03,l_ksc.ksc02,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ksc.ksc01,l_ksd.ksd03,l_ksc.ksc02) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                       l_ksd.ksd06,l_ksd.ksd07,
                       l_ksd.ksd30) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ksd.ksd30,l_ksc.ksc01,l_ksd.ksd03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ksd.ksd30,l_ksc.ksc01,l_ksd.ksd03) #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_ksd.ksd04,l_ksd.ksd05,
                       l_ksd.ksd06,l_ksd.ksd07,
                       l_ksd.ksd33) RETURNING l_flag
       IF l_flag = 1 THEN
          #CALL s_padd_imgg_data(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ksd.ksd33,l_ksc.ksc01,l_ksd.ksd03,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ksd.ksd33,l_ksc.ksc01,l_ksd.ksd03) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_img FROM l_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET l_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM l_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end    
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_drop(l_img_table)  #FUN-CC0095
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
               #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_drop(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
               #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
               RETURN 
            END IF 
         END IF #FUN-CC0095  
      ELSE
         #CALL s_padd_img_drop(l_img_table) #FUN-CC0095
         #CALL s_padd_imgg_drop(l_imgg_table) #FUN-CC0095
         LET g_success = 'N'
         #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #CHI-CB0041
         #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #CHI-CB0041
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
 
   CALL t622sub_lock_cl() #FUN-730012
   OPEN t622sub_cl USING l_ksc.ksc01
   IF STATUS THEN
      CALL cl_err("OPEN t622sub_cl:", STATUS, 1)
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028  #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028  #FUN-CC0095
      RETURN
   END IF
 
   FETCH t622sub_cl INTO l_ksc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ksc:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' 
      #CALL s_padd_img_drop(l_img_table)   #TQC-CA0028 #FUN-CC0095
      #CALL s_padd_imgg_drop(l_imgg_table) #TQC-CA0028 #FUN-CC0095
      RETURN
   END IF
 
 
   #LET g_success = 'Y'  #marked by carrier
 
   UPDATE ksc_file SET kscpost='Y'  ,
                       ksc02=l_ksc.ksc02
    WHERE ksc01=l_ksc.ksc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','ksc_file',l_ksc.ksc01,'',SQLCA.sqlcode,'','','1')   #TQC-C50236 add
      LET l_ksc.ksc02 = l_ksc02
      LET g_success='N'
   END IF
   
   #FUN-5C0114...............begin
   CALL t622sub_s1(l_ksc.ksc01,p_argv)
   
   IF g_success = 'Y' THEN
      LET l_ksc.kscpost='Y'
      IF NOT p_inTransaction THEN COMMIT WORK END IF
      CALL cl_flow_notify(l_ksc.ksc01,'S')
   ELSE
      LET l_ksc.kscpost='N'
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
   #CALL s_padd_img_drop(l_img_table)   #FUN-C70087 #FUN-CC0095
   #CALL s_padd_imgg_drop(l_imgg_table) #FUN-C70087 #FUN-CC0095
END FUNCTION
 
FUNCTION t622sub_s1(p_ksc01,p_argv)
  DEFINE p_ksc01    LIKE ksc_file.ksc01
  DEFINE p_argv     LIKE type_file.chr1
  DEFINE l_ksc      RECORD LIKE ksc_file.*
  DEFINE l_ksd      RECORD LIKE ksd_file.*
  DEFINE l_sfb      RECORD LIKE sfb_file.*
  DEFINE l_ksd091   LIKE ksd_file.ksd09,
         l_ksd092   LIKE ksd_file.ksd09,
         l_ksd09    LIKE ksd_file.ksd09,
         l_qcf091   LIKE qcf_file.qcf091,
         l_str      LIKE type_file.chr20,         #No.FUN-680121 SMALLINT #No.MOD-5B0054 add
         l_cnt      LIKE type_file.num5,          #No.MOD-5B0054 add        #No.FUN-680121 SMALLINT
         s_ksd09    LIKE ksd_file.ksd09
  DEFINE l_flag        LIKE type_file.num5                 #FUN-810038
  DEFINE l_ima153     LIKE ima_file.ima153   #FUN-910053 
  DEFINE l_min_set    LIKE sfb_file.sfb08
  DEFINE l_ecm311     LIKE ecm_file.ecm311
  DEFINE l_ecm315     LIKE ecm_file.ecm315
  DEFINE l_ecm_out    LIKE ecm_file.ecm311
  DEFINE l_sfb04      LIKE sfb_file.sfb04
 
 
  CALL s_showmsg_init()   #No.FUN-6C0083 
  
  IF g_success='N' THEN RETURN END IF
  SELECT * INTO l_ksc.* FROM ksc_file WHERE ksc01 = p_ksc01
   
  DECLARE t622sub_s1_c CURSOR FOR
   SELECT * FROM ksd_file WHERE ksd01=l_ksc.ksc01
 
  FOREACH t622sub_s1_c INTO l_ksd.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('foreach t622sub_s1_c',SQLCA.sqlcode,1)
        EXIT FOREACH
     END IF
     
     IF cl_null(l_ksd.ksd04) THEN
        CONTINUE FOREACH
     END IF
     MESSAGE '_s1() read ksd:',l_ksd.ksd03
 
     #No.B363
     SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01=l_ksd.ksd11
     IF l_sfb04='8' THEN
        CALL cl_err(l_ksd.ksd01,'mfg3430',1)
        LET g_success='N'
        EXIT FOREACH
     END IF
     #No.B363 END
 
     IF l_ksd.ksd09 = 0 THEN
        CALL cl_err(l_ksd.ksd09,'asf-660',1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
      #----FQC No.不為null,入庫量+驗退量不可大於FQC量
      IF p_argv = '1' OR p_argv = '2' THEN   #完工入庫或入庫退回
         #-----更新sfb_file-----------
          LET l_ksd091 = 0    LET l_ksd092 = 0  LET l_ksd09 = 0
          SELECT SUM(ksd09) INTO l_ksd091 FROM ksc_file,ksd_file
           WHERE ksd11 = l_ksd.ksd11
             AND ksc01 = ksd01
             AND ksd04 = l_ksd.ksd04
             AND ksc00 = '1'           #完工入庫
             AND kscpost = 'Y'
          SELECT SUM(ksd09) INTO l_ksd092 FROM ksc_file,ksd_file
           WHERE ksd11 = l_ksd.ksd11
             AND ksc01 = ksd01
             AND ksd04 = l_ksd.ksd04
             AND ksc00 = '2'           #入庫退回
             AND kscpost = 'Y'
         LET l_ksd09 = 0
         IF cl_null(l_ksd091) THEN LET l_ksd091 = 0 END IF
         IF cl_null(l_ksd092) THEN LET l_ksd092 = 0 END IF
         LET l_ksd09 = l_ksd091 - l_ksd092
         IF p_argv = '1' THEN #完工入庫
            UPDATE sfb_file SET sfb04 = '7'
             WHERE sfb01 = l_ksd.ksd11
         END IF
      END IF
      IF STATUS THEN
         CALL cl_err('upd sfb',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF SQLCA.sqlerrd[3]=0 THEN
         #CALL cl_err('upd sfb','mfg0177',1)                                         #TQC-C50236 mark
         CALL cl_err3("upd","sfb_file",l_ksd.ksd11,"",SQLCA.sqlcode,"","upd sfb",1)  #TQC-C50236 add
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
     #------
     #IF l_ksc.ksc03 IS NOT NULL THEN   #CHI-950036
      IF l_ksd.ksd17 IS NOT NULL THEN   #CHI-950036
         SELECT SUM(ksd09) INTO s_ksd09
           FROM ksc_file,ksd_file
         #WHERE ksc03 = l_ksc.ksc03     #CHI-950036
          WHERE ksd17 = l_ksd.ksd17     #CHI-950036
            AND ksd11 = l_ksd.ksd11
            AND ksd04 = l_ksd.ksd04
            AND ksd01 = ksc01
            AND kscpost = 'Y' AND ksc00='1'
         IF s_ksd09 IS NULL THEN LET s_ksd09 = 0 END IF
     END IF
 
    # 98.06.10 Star 暫不新增到統計檔
    #IF g_argv = '1' OR g_argv = '2' THEN    #完工入庫或入庫退回
    #  #------新增拆件式工單完工統計資料檔(sfh_file)---
    #  INSERT INTO sfh_file VALUES (b_ksd.ksd11,g_ksc.ksc02,'3',b_ksd.ksd04,
    #                              ' ',b_ksd.ksd09,b_ksd.ksd08,b_ksd.ksd05,
    #                              b_ksd.ksd06,b_ksd.ksd07,' ',' ',g_ksc.ksc01,
    #                              0,0,0,0,' ',' ',' ')
    # IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
    #    CALL cl_err('ins sfh',STATUS,1) LET g_success = 'N' RETURN
    # END IF
    #END IF
 
    IF p_argv = '1' OR p_argv = '2' THEN
       #No.FUN-540055  --begin
       IF g_sma.sma115 = 'Y' THEN
          IF l_ksd.ksd32 != 0 OR l_ksd.ksd35 != 0 THEN
             CALL t622sub_update_du('s',p_argv,l_ksc.ksc01,l_ksd.ksd03)
             IF g_success='N' THEN 
                #TQC-620156...............begin
                LET g_totsuccess='N'
                LET g_success="Y"
                CONTINUE FOREACH   #No.FUN-6C0083
                #RETURN
                #TQC-620156...............end
             END IF
          END IF
       END IF
       #No.FUN-540055  --end
       IF l_ksd.ksd09 != 0 THEN
           CALL t622sub_update_s(l_ksc.ksc01,l_ksd.ksd03,p_argv)
           IF g_success='N' THEN
              #TQC-620156...............begin
              LET g_totsuccess='N'
              LET g_success="Y"
              CONTINUE FOREACH   #No.FUN-6C0083
              #RETURN
              #TQC-620156...............end
           END IF
       END IF
    END IF
  END FOREACH
  MESSAGE ''
  #TQC-620156...............begin
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
  CALL s_showmsg()   #No.FUN-6C0083
 
  #TQC-620156...............end
  CALL cl_msg('')
 
END FUNCTION
 
FUNCTION t622sub_update_du(p_type,p_argv,p_ksc01,p_ksd03)
   DEFINE p_type    LIKE type_file.chr1 
   DEFINE p_argv    LIKE type_file.chr1
   DEFINE p_ksc01   LIKE ksc_file.ksc01
   DEFINE p_ksd03   LIKE ksd_file.ksd03
   DEFINE l_ima25   LIKE ima_file.ima25
   DEFINE u_type    LIKE type_file.num5
   DEFINE l_ima906  LIKE ima_file.ima906
   DEFINE l_ima907  LIKE ima_file.ima907
   DEFINE l_ksc     RECORD LIKE ksc_file.*
   DEFINE l_ksd     RECORD LIKE ksd_file.*
 
 
   IF g_sma.sma115 = 'N' THEN RETURN END IF
 
   IF g_success = 'N' THEN RETURN END IF
   IF cl_null(p_ksc01) THEN LET g_success = 'N' RETURN END IF
   IF cl_null(p_ksd03) THEN LET g_success = 'N' RETURN END IF
   
   SELECT * INTO l_ksc.* FROM ksc_file
    WHERE ksc01 = p_ksc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','',1)
      LET g_success = 'N'
      RETURN
   END IF
   
   SELECT * INTO l_ksd.* FROM ksd_file 
    WHERE ksd01 = p_ksc01
      AND ksd03 = p_ksd03
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksd_file',p_ksc01,p_ksd03,SQLCA.sqlcode,'','',1)
      LET g_success = 'N'
      RETURN
   END IF   
 
   IF p_type = 's' THEN
      CASE WHEN p_argv ='1' LET u_type=+1
           WHEN p_argv ='2' LET u_type=-1
      END CASE
   ELSE
      CASE WHEN p_argv ='1' LET u_type=-1
           WHEN p_argv ='2' LET u_type=+1
      END CASE
   END IF
 
   SELECT ima906,ima907,ima25 INTO l_ima906,l_ima907,l_ima25 FROM ima_file
    WHERE ima01 = l_ksd.ksd04
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ima_file',l_ksd.ksd04,'',SQLCA.sqlcode,'','','1')
      LET g_success='N' RETURN
   END IF
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_ksd.ksd33) THEN
         CALL t622sub_upd_imgg('1',l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,
                            l_ksd.ksd07,l_ksd.ksd33,l_ksd.ksd34,l_ksd.ksd35,u_type,'2',l_ksc.ksc02)
         IF g_success='N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(l_ksd.ksd35) AND l_ksd.ksd35 <> 0 THEN
               CALL t622sub_tlff(l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ima25,
                              l_ksd.ksd35,0,l_ksd.ksd33,l_ksd.ksd34,u_type,'2',l_ksc.ksc01,l_ksd.ksd03,p_argv)
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF NOT cl_null(l_ksd.ksd30) THEN
         CALL t622sub_upd_imgg('1',l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,
                            l_ksd.ksd07,l_ksd.ksd30,l_ksd.ksd31,l_ksd.ksd32,u_type,'1',l_ksc.ksc02)
         IF g_success='N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(l_ksd.ksd32) AND l_ksd.ksd32 <> 0 THEN
               CALL t622sub_tlff(l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ima25,
                           l_ksd.ksd32,0,l_ksd.ksd30,l_ksd.ksd31,u_type,'1',l_ksc.ksc01,l_ksd.ksd03,p_argv)
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF p_type = 'w' THEN
         CALL t622sub_tlff_w(l_ksc.ksc01,l_ksc.ksc02,l_ksd.ksd03,l_ksd.ksd04)
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_ksd.ksd33) THEN
         CALL t622sub_upd_imgg('2',l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,
                            l_ksd.ksd07,l_ksd.ksd33,l_ksd.ksd34,l_ksd.ksd35,u_type,'2',l_ksc.ksc02)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type = 's' THEN
            IF NOT cl_null(l_ksd.ksd35) AND l_ksd.ksd35 <> 0 THEN
               CALL t622sub_tlff(l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ima25,
                              l_ksd.ksd35,0,l_ksd.ksd33,l_ksd.ksd34,u_type,'2',l_ksc.ksc01,l_ksd.ksd03,p_argv)
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      #No.CHI-770019  --Begin
      #IF NOT cl_null(l_ksd.ksd30) AND p_type = 's' THEN
      #   IF NOT cl_null(l_ksd.ksd32) AND l_ksd.ksd32 <> 0 THEN
      #      CALL t622sub_tlff(l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,l_ima25,
      #                     l_ksd.ksd32,0,l_ksd.ksd30,l_ksd.ksd31,u_type,'1')
      #      IF g_success='N' THEN RETURN END IF
      #   END IF
      #END IF
      #No.CHI-770019  --End  
      IF p_type = 'w' THEN
         CALL t622sub_tlff_w(l_ksc.ksc01,l_ksc.ksc02,l_ksd.ksd03,l_ksd.ksd04)
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t622sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_ksc02)
  DEFINE p_ksc02    LIKE ksc_file.ksc02
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(01),
         p_type     LIKE type_file.num10    #No.FUN-680121 INTEGER
   DEFINE l_forupd_sql    STRING
   DEFINE l_cnt           LIKE type_file.num5

#091021 --begin-- 
#    LET l_forupd_sql =
#        "SELECT rowi FROM imgg_file ",
#        " WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
#        "   AND imgg09= ? FOR UPDATE "
#    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)
#
#    DECLARE imgg_lock CURSOR FROM l_forupd_sql
 
#    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
#    IF STATUS THEN
#       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
#       LET g_success='N'
#       CLOSE imgg_lock
#       #ROLLBACK WORK       #TQC-930155 mark
#       RETURN
#    END IF
#    FETCH imgg_lock INTO l_rowi
#    IF STATUS THEN
#       CALL cl_err('lock imgg fail',STATUS,1)
#       LET g_success='N'
#       CLOSE imgg_lock
#       #ROLLBACK WORK      #TQC-930155 mark
#       RETURN
#    END IF
#091021 --end--
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1)  #No.FUN-660128
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
   #CALL s_upimgg(l_rowi,p_type,p_imgg10,g_ksc.ksc02,  #FUN-8C0084
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_ksc02,  #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t622sub_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   u_type,p_flag,p_ksc01,p_ksd03,p_argv)
   DEFINE p_ksc01     LIKE ksc_file.ksc01
   DEFINE p_ksd03     LIKE ksd_file.ksd03
   DEFINE p_argv      LIKE type_file.chr1
DEFINE
#  l_ima262   LIKE ima_file.ima262,
   l_avl_stk  LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A40023
   l_ima25    LIKE ima_file.ima25,
   l_ima55    LIKE ima_file.ima55,
   l_ima86    LIKE ima_file.ima86,
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   l_imgg10   LIKE imgg_file.imgg10,
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   u_type     LIKE type_file.num5,    #No.FUN-680121 SMALLINT,##+1:雜收 -1:雜發  0:報廢
   p_flag     LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
   g_cnt      LIKE type_file.num5     #No.FUN-680121 SMALLINT
   DEFINE l_ksc    RECORD LIKE ksc_file.*
   DEFINE l_ksd    RECORD LIKE ksd_file.*
 
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_ksc01) OR cl_null(p_ksd03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_ksc.* FROM ksc_file
     WHERE ksc01 = p_ksc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_ksd.* FROM ksd_file
     WHERE ksd01 = p_ksc01
       AND ksd03 = p_ksd03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksd_file',p_ksc01,p_ksd03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF    
 
#  CALL s_getima(l_ksd.ksd04) RETURNING l_ima262,l_ima25,l_ima55,l_ima86   #NO.FUN-A40023
   CALL s_getima(l_ksd.ksd04) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86  #NO.FUN-A40023
 
   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
   IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
   IF p_uom IS NULL THEN
      CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
   SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=l_ksd.ksd04 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
   INITIALIZE g_tlff.* TO NULL
 
    #  Source
    LET g_tlff.tlff01=l_ksd.ksd04      #異動料件編號
    IF p_argv = '1' THEN
       LET g_tlff.tlff02=65               #資料來源為拆件式工單
       LET g_tlff.tlff020=' '
       LET g_tlff.tlff021=' '             #倉庫別
       LET g_tlff.tlff022=' '             #儲位別
       LET g_tlff.tlff023=' '             #批號
    ELSE
       LET g_tlff.tlff02=50               #資料目的為倉庫
       LET g_tlff.tlff020=g_plant
       LET g_tlff.tlff021=p_ware          #倉庫別
       LET g_tlff.tlff022=p_loca          #儲位別
       LET g_tlff.tlff023=p_lot           #入庫批號
    END IF
       LET g_tlff.tlff024=l_imgg10        #異動後庫存數量(同料件主檔之可用量)
       LET g_tlff.tlff025=p_unit          #庫存單位(同料件之庫存單位)
       LET g_tlff.tlff026=l_ksc.ksc01     #單据編號(拆件式工單單號)
       LET g_tlff.tlff027=l_ksd.ksd03     #單據項次
    #  Target
    IF p_argv = '1' THEN
       LET g_tlff.tlff03=50               #資料目的為倉庫
       LET g_tlff.tlff030=g_plant
       LET g_tlff.tlff031=p_ware          #倉庫別
       LET g_tlff.tlff032=p_loca          #儲位別
       LET g_tlff.tlff033=p_lot           #入庫批號
    ELSE
       LET g_tlff.tlff03=65               #資料來源為拆件式工單
       LET g_tlff.tlff030=' '
       LET g_tlff.tlff031=' '             #倉庫別
       LET g_tlff.tlff032=' '             #儲位別
       LET g_tlff.tlff033=' '             #批號
    END IF
    LET g_tlff.tlff034=l_imgg10        #異動後庫存數量(同料件主檔之可用量)
    LET g_tlff.tlff035=p_unit          #生產單位
    LET g_tlff.tlff036=l_ksc.ksc01     #參考號碼
    LET g_tlff.tlff037=l_ksd.ksd03     #項次
 
    LET g_tlff.tlff04=' '              #工作站
    LET g_tlff.tlff05=' '              #作業序號
    LET g_tlff.tlff06=l_ksc.ksc02      #入庫日期
    LET g_tlff.tlff07=g_today          #異動資料產生日期
    LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user           #產生人
    LET g_tlff.tlff10=p_qty            #入庫量
    LET g_tlff.tlff11=p_uom            #生產單位
    LET g_tlff.tlff12=p_factor         #發料/庫存轉換率
    IF p_argv = '1' THEN
       LET g_tlff.tlff13= 'asft6201'
    ELSE
       LET g_tlff.tlff13= 'asft660'
    END IF
    LET g_tlff.tlff14=''               #原因
    LET g_tlff.tlff15=''               #借方會計科目
    LET g_tlff.tlff16=''               #貸方會計科目
    LET g_tlff.tlff17=' '              #非庫存性料件編號
    CALL s_imaQOH(l_ksd.ksd04)
       RETURNING g_tlff.tlff18         #異動後總庫存量
    LET g_tlff.tlff19= ''              #部門
    LET g_tlff.tlff20= ''              #project no.
    LET g_tlff.tlff21= ''
    LET g_tlff.tlff61= ''
    LET g_tlff.tlff62= l_ksd.ksd11     #單据編號(拆件式工單單號)
    LET g_tlff.tlff63= ''
    LET g_tlff.tlff64= ''
    LET g_tlff.tlff65= ''
    LET g_tlff.tlff66= ''
    LET g_tlff.tlff930= l_ksd.ksd930 #FUN-670103
    
    IF cl_null(l_ksd.ksd35) OR l_ksd.ksd35=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,l_ksd.ksd33)
    END IF
END FUNCTION
 
FUNCTION t622sub_tlff_w(p_ksc01,p_ksc02,p_ksd03,p_ksd04)
   DEFINE p_ksc01       LIKE ksc_file.ksc01
   DEFINE p_ksc02       LIKE ksc_file.ksc02
   DEFINE p_ksd03       LIKE ksd_file.ksd03
   DEFINE p_ksd04       LIKE ksd_file.ksd04
 
    CALL cl_msg("d_tlff!")
    CALL ui.Interface.refresh()
 
    DELETE FROM tlff_file
     WHERE tlff01 =p_ksd04
       AND ((tlff026=p_ksc01 AND tlff027=p_ksd03) OR
            (tlff036=p_ksc01 AND tlff037=p_ksd03)) #異動單號/項次
       AND tlff06 =p_ksc02 #異動日期
 
    IF STATUS THEN
       CALL cl_err('del tlff:',STATUS,1) LET g_success='N' RETURN
    END IF
END FUNCTION
 
#FUN-540055  --end
 
FUNCTION t622sub_update_s(p_ksc01,p_ksd03,p_argv)
  DEFINE p_ksc01       LIKE ksc_file.ksc01
  DEFINE p_ksd03       LIKE ksd_file.ksd03
  DEFINE p_argv        LIKE type_file.chr1
  DEFINE p_ware        LIKE img_file.img02
  DEFINE p_loca        LIKE img_file.img03
  DEFINE p_lot         LIKE img_file.img04
  DEFINE p_qty         LIKE img_file.img10        ##數量
  DEFINE p_uom         LIKE img_file.img09        ##img 單位
  DEFINE p_factor      LIKE ima_file.ima31_fac    ##轉換率
  DEFINE l_qty         LIKE img_file.img10        ##異動後數量
  DEFINE l_ima01       LIKE ima_file.ima01
  DEFINE l_ima25       LIKE ima_file.ima25
  DEFINE l_ima55       LIKE ima_file.ima55
# DEFINE l_imaqty      LIKE ima_file.ima262
  DEFINE l_imaqty      LIKE type_file.num15_3     ###GP5.2  #NO.FUN-A40023
  DEFINE l_imafac      LIKE img_file.img21
  DEFINE u_type        LIKE type_file.num5        ##+1:入庫 -1:入庫退回
  DEFINE l_img         RECORD
                       img10   LIKE img_file.img10,
                       img16   LIKE img_file.img16,
                       img23   LIKE img_file.img23,
                       img24   LIKE img_file.img24,
                       img09   LIKE img_file.img09,
                       img21   LIKE img_file.img21
                       END RECORD
  DEFINE l_img09       LIKE img_file.img09  
  DEFINE l_ksc         RECORD LIKE ksc_file.*
  DEFINE l_ksd         RECORD LIKE ksd_file.*
  DEFINE l_i           LIKE type_file.num5  
  DEFINE l_ima86       LIKE ima_file.ima86
  DEFINE l_cnt         LIKE type_file.num10
  DEFINE l_sql         STRING
  DEFINE l_forupd_sql  STRING
  
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_ksc01) OR cl_null(p_ksd03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_ksc.* FROM ksc_file
     WHERE ksc01 = p_ksc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_ksd.* FROM ksd_file
     WHERE ksd01 = p_ksc01
       AND ksd03 = p_ksd03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksd_file',p_ksc01,p_ksd03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF 
    
    LET p_ware = l_ksd.ksd05
    LET p_loca = l_ksd.ksd06
    LET p_lot  = l_ksd.ksd07
    LET p_qty  = l_ksd.ksd09
    LET p_uom  = l_ksd.ksd08
     
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
                                   #生產單位
    #No:9697
    IF cl_null(l_ksd.ksd06) THEN LET l_ksd.ksd06=' ' END IF
    IF cl_null(l_ksd.ksd07) THEN LET l_ksd.ksd07=' ' END IF
    #No:9697
 
## No:2572 modify 1998/10/20 ----------------------------------
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=l_ksd.ksd04 AND img02=l_ksd.ksd05
       AND img03=l_ksd.ksd06 AND img04=l_ksd.ksd07
    IF STATUS THEN
       CALL cl_err('sel img09',status,1) LET g_success = 'N' RETURN
    END IF
## --------------------------------------------------------------
 
    CALL s_umfchk(l_ksd.ksd04,p_uom,l_img09) RETURNING l_i,p_factor
    IF l_i = 1 THEN
        ###Modify:98/11/15 ----庫存/料號單位無法轉換 ------####
        #CALL cl_err('庫存/料號單位無法轉換',STATUS,1)
        CALL cl_err('ksd08/img09: ','abm-731',1)
        LET g_success ='N'
        ####LET p_factor = 1
    END IF
    IF p_uom IS NULL THEN
      #CALL cl_err('p_uom null:','',1) LET g_success = 'N' RETURN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
#------------------------------------------- update img_file
    CALL cl_msg("update img_file ...")
 
#    LET l_forupd_sql = "SELECT rowi,img10,img16,img23,img24,img09,img21 ", #091021 --mark
     LET l_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ", #091021 
                       "FROM img_file",
                       " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ? ",
                       " FOR UPDATE"
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)    #No.FUN-9B0059
    DECLARE img_lock CURSOR FROM l_forupd_sql
 
    OPEN img_lock USING l_ksd.ksd04,p_ware,p_loca, p_lot
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH img_lock INTO l_img.*
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
 
    IF p_argv = '2' THEN    #退回
       LET l_qty= l_img.img10 - p_qty
       IF l_qty < 0 THEN  #庫存不足, Fail
          IF NOT cl_confirm('mfg3469') THEN  LET g_success='N' RETURN END IF
       END IF
    END IF
 
    CASE WHEN p_argv = '1' LET u_type = +1
         WHEN p_argv = '2' LET u_type = -1
         WHEN p_argv = '3' LET u_type = +1 #FUN-5C0114
    END CASE
 
    #FUN-550011................begin
    IF u_type = -1 THEN
      #FUN-D30024--modify--str--
      #IF NOT s_stkminus(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,
      #                  l_ksd.ksd09,p_factor,l_ksc.ksc02,g_sma.sma894[3,3]) THEN
       IF NOT s_stkminus(l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,l_ksd.ksd07,
                         l_ksd.ksd09,p_factor,l_ksc.ksc02) THEN
      #FUN-D30024--modify--end--
          LET g_success='N'
          RETURN
       END IF
    END IF
    #FUN-550011................end
 
   #CALL s_upimg(l_img.rowi,u_type,p_qty*p_factor,g_today,  #FUN-8C0084
    CALL s_upimg(l_ksd.ksd04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today,  #FUN-8C0084
                 '','','','',l_ksd.ksd01,l_ksd.ksd03,   #No.MOD-860261
                 '','','','','','','','','','','','')
    IF g_success='N' THEN RETURN END IF
#------------------------------------------- update ima_file
    CALL cl_msg("update ima_file ...")
 
    LET l_forupd_sql=
        "SELECT ima25,ima86 FROM ima_file WHERE ima01= ? FOR UPDATE"
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)    #No.FUN-9B0059
    DECLARE ima_lock CURSOR FROM l_forupd_sql
 
    OPEN ima_lock USING l_ksd.ksd04
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH ima_lock INTO l_ima25,l_ima86
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
    IF l_ksd.ksd08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(l_ksd.ksd04,l_ksd.ksd08,l_ima25)
                RETURNING l_cnt,l_imafac
    END IF
    IF cl_null(l_imafac)  THEN
       ####Modify:98/11/15 ----庫存/料號無法轉換 -------###
       #CALL cl_err('庫存/料號單位無法轉換',STATUS,1)
       CALL cl_err('ksd08/ima25: ','abm-731',1)
       LET g_success ='N'
       ####LET l_imafac = 1
    END IF
    LET l_imaqty = p_qty * l_imafac
    CALL s_udima(l_ksd.ksd04,l_img.img23,l_img.img24,l_imaqty,
                    g_today,u_type)  RETURNING l_cnt
    IF g_success='N' THEN RETURN END IF
    #ksd
#------------------------------------------- insert tlf_file
    CALL cl_msg("insert tlf_file ...")
    IF g_success='Y' THEN
       IF l_ksd.ksd09 != 0 THEN
          CALL t622sub_tlf(p_factor,l_ksc.ksc01,l_ksd.ksd03,p_argv)
       END IF
    END IF
    LET l_sql="seq#",l_ksd.ksd03 USING'<<<',' post ok!'
    CALL cl_msg(l_sql)
END FUNCTION
 
FUNCTION t622sub_tlf(p_factor,p_ksc01,p_ksd03,p_argv)
  DEFINE p_ksc01       LIKE ksc_file.ksc01
  DEFINE p_ksd03       LIKE ksd_file.ksd03
  DEFINE p_argv        LIKE type_file.chr1
  DEFINE l_ksc         RECORD LIKE ksc_file.*
  DEFINE l_ksd         RECORD LIKE ksd_file.*
# DEFINE l_ima262      LIKE ima_file.ima262
  DEFINE l_avl_stk     LIKE type_file.num15_3  ###GP5.2  #NO.FUN-A40023
  DEFINE l_ima25       LIKE ima_file.ima25
  DEFINE l_ima55       LIKE ima_file.ima55
  DEFINE l_ima86       LIKE ima_file.ima86
  DEFINE p_factor      LIKE ima_file.ima31_fac ##轉換率
  DEFINE p_img10       LIKE img_file.img10     #異動後數量
  DEFINE l_img09       LIKE img_file.img09     #No: MOD-570344 add
  DEFINE l_sfb97       LIKE sfb_file.sfb97
 
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_ksc01) OR cl_null(p_ksd03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_ksc.* FROM ksc_file
     WHERE ksc01 = p_ksc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_ksd.* FROM ksd_file
     WHERE ksd01 = p_ksc01
       AND ksd03 = p_ksd03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksd_file',p_ksc01,p_ksd03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF 
    
    IF l_ksd.ksd09 = 0 THEN RETURN END IF
     #--No.MOD-570344
    SELECT img09,img10 INTO l_img09,p_img10 FROM img_file
         WHERE img01 = l_ksd.ksd04 AND img02 = l_ksd.ksd05
           AND img03 = l_ksd.ksd06 AND img04 = l_ksd.ksd07
    #--No.MOD-570344 end
 
   INITIALIZE g_tlf.* TO NULL
#   CALL s_getima(l_ksd.ksd04) RETURNING l_ima262,l_ima25,l_ima55,l_ima86    #NO.FUN-A40023
    CALL s_getima(l_ksd.ksd04) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86   #NO.FUN-A40023
    #  Source
    LET g_tlf.tlf01=l_ksd.ksd04      #異動料件編號
    IF p_argv = '1' THEN
       LET g_tlf.tlf02=65               #資料來源為拆件式工單
       LET g_tlf.tlf020=' '
       LET g_tlf.tlf021=' '             #倉庫別
       LET g_tlf.tlf022=' '             #儲位別
       LET g_tlf.tlf023=' '             #批號
    ELSE
       LET g_tlf.tlf02=50               #資料目的為倉庫
       LET g_tlf.tlf020=g_plant
       LET g_tlf.tlf021=l_ksd.ksd05     #倉庫別
       LET g_tlf.tlf022=l_ksd.ksd06     #儲位別
       LET g_tlf.tlf023=l_ksd.ksd07     #入庫批號
    END IF
        #---No.MOD-570344 modify
       #LET g_tlf.tlf024=l_ima262        #異動後庫存數量(同料件主檔之可用量)
       #LET g_tlf.tlf025=l_ima25         #庫存單位(同料件之庫存單位)
       LET g_tlf.tlf024=p_img10
       LET g_tlf.tlf025=l_img09
       #--No.MOD-570344 end
       LET g_tlf.tlf026=l_ksc.ksc01     #單据編號(拆件式工單單號)
       LET g_tlf.tlf027=l_ksd.ksd03     #單據項次
    #  Target
    IF p_argv = '1' THEN
       LET g_tlf.tlf03=50               #資料目的為倉庫
       LET g_tlf.tlf030=g_plant
       LET g_tlf.tlf031=l_ksd.ksd05     #倉庫別
       LET g_tlf.tlf032=l_ksd.ksd06     #儲位別
       LET g_tlf.tlf033=l_ksd.ksd07     #入庫批號
    ELSE
       LET g_tlf.tlf03=65               #資料來源為拆件式工單
       LET g_tlf.tlf030=' '
       LET g_tlf.tlf031=' '             #倉庫別
       LET g_tlf.tlf032=' '             #儲位別
       LET g_tlf.tlf033=' '             #批號
    END IF
     #---No.MOD-570344 modify
       #LET g_tlf.tlf034=l_ima262        #異動後庫存數量(同料件主檔之可用量)
       #LET g_tlf.tlf035=l_ima25         #庫存單位(同料件之庫存單位)
       LET g_tlf.tlf034=p_img10
       LET g_tlf.tlf035=l_img09
       #--No.MOD-570344 end
    LET g_tlf.tlf036=l_ksc.ksc01     #參考號碼
    LET g_tlf.tlf037=l_ksd.ksd03     #項次
 
    LET g_tlf.tlf04=' '              #工作站
    LET g_tlf.tlf05=' '              #作業序號
    LET g_tlf.tlf06=l_ksc.ksc02      #入庫日期
    LET g_tlf.tlf07=g_today          #異動資料產生日期
    LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user           #產生人
    LET g_tlf.tlf10=l_ksd.ksd09      #入庫量
    LET g_tlf.tlf11=l_ksd.ksd08      #生產單位
    LET g_tlf.tlf12=p_factor         #發料/庫存轉換率
    IF p_argv = '1' THEN
       LET g_tlf.tlf13= 'asft6201'
    ELSE
       LET g_tlf.tlf13= 'asft660'
    END IF
    LET g_tlf.tlf14=''               #原因
    LET g_tlf.tlf15=''               #借方會計科目
    LET g_tlf.tlf16=''               #貸方會計科目
    LET g_tlf.tlf17=' '              #非庫存性料件編號
    CALL s_imaQOH(l_ksd.ksd04)
       RETURNING g_tlf.tlf18         #異動後總庫存量
    LET g_tlf.tlf19= ''              #部門
    LET g_tlf.tlf20= ''              #project no.
    LET g_tlf.tlf21= ''
    LET g_tlf.tlf61= ''
    LET g_tlf.tlf62= l_ksd.ksd11     #單据編號(拆件式工單單號)
    LET g_tlf.tlf63= ''
    LET g_tlf.tlf64= ''
    LET g_tlf.tlf65= ''
    LET g_tlf.tlf66= ''
    LET g_tlf.tlf930= l_ksd.ksd930 #FUN-670103
    CALL s_tlf(1,0)                  #1:需取得標準成本 0:不需詢問原因
END FUNCTION
 
 
#check later
FUNCTION t622sub_update_w(p_ksc01,p_ksd03,p_argv)
  DEFINE p_ksc01       LIKE ksc_file.ksc01
  DEFINE p_ksd03       LIKE ksd_file.ksd03
  DEFINE p_argv        LIKE type_file.chr1  
  DEFINE p_ware        LIKE img_file.img02
  DEFINE p_loca        LIKE img_file.img03
  DEFINE p_lot         LIKE img_file.img04
  DEFINE p_qty         LIKE img_file.img10        ##數量
  DEFINE p_uom         LIKE img_file.img09        ##img 單
  DEFINE u_type        LIKE type_file.num5        ##-1:入庫 +1:入庫退回
  DEFINE p_factor      LIKE ima_file.ima31_fac    ##轉換率
  DEFINE l_qty         LIKE img_file.img10        ##異動後數量
  DEFINE l_ima01       LIKE ima_file.ima01
  DEFINE l_ima25       LIKE ima_file.ima25
  DEFINE l_ima55       LIKE ima_file.ima55
# DEFINE l_imaqty      LIKE ima_file.ima262
  DEFINE l_imaqty      LIKE type_file.num15_3     ###GP5.2  #NO.FUN-A40023
  DEFINE l_imafac      LIKE img_file.img21
  DEFINE l_img         RECORD
                       img10   LIKE img_file.img10,
                       img16   LIKE img_file.img16,
                       img23   LIKE img_file.img23,
                       img24   LIKE img_file.img24,
                       img09   LIKE img_file.img09,
                       img21   LIKE img_file.img21
                       END RECORD
  DEFINE l_img09       LIKE img_file.img09  
  DEFINE l_ksc         RECORD LIKE ksc_file.*
  DEFINE l_ksd         RECORD LIKE ksd_file.*
  DEFINE l_i           LIKE type_file.num5  
  DEFINE l_ima86       LIKE ima_file.ima86
  DEFINE l_cnt         LIKE type_file.num10
  DEFINE l_forupd_sql  STRING
 
    IF g_success = 'N' THEN RETURN END IF
    IF cl_null(p_ksc01) OR cl_null(p_ksd03) THEN LET g_success = 'N' END IF
    
    SELECT * INTO l_ksc.* FROM ksc_file
     WHERE ksc01 = p_ksc01
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT * INTO l_ksd.* FROM ksd_file
     WHERE ksd01 = p_ksc01
       AND ksd03 = p_ksd03
    IF SQLCA.sqlcode THEN
       CALL cl_err3('sel','ksd_file',p_ksc01,p_ksd03,SQLCA.sqlcode,'','','1')
       LET g_success = 'N'
       RETURN
    END IF 
    
    LET p_ware = l_ksd.ksd05
    LET p_loca = l_ksd.ksd06
    LET p_lot  = l_ksd.ksd07
    LET p_qty  = l_ksd.ksd09
    LET p_uom  = l_ksd.ksd08
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01=l_ksd.ksd04 AND img02=l_ksd.ksd05
       AND img03=l_ksd.ksd06 AND img04=l_ksd.ksd07
    IF STATUS THEN
       CALL cl_err('sel img09',status,1)
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL s_umfchk(l_ksd.ksd04,p_uom,l_img09) RETURNING l_i,p_factor
    IF l_i = 1 THEN
        ####Modify:98/11/15 ----庫存/料號單位無法轉換-----###
        #CALL cl_err('庫存/料號單位無法轉換',STATUS,1)
        CALL cl_err('ksd08/img09: ','abm-731',1)
        LET g_success ='N'
    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1)
       LET g_success = 'N'
       RETURN
    END IF
 
    CALL cl_msg("update img_file ...")
 
#    LET l_forupd_sql = "SELECT rowi,img10,img16,img23,img24,img09,img21", #091021 --mark
     LET l_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21", #091021 
                       " FROM img_file ",
                       "WHERE img01= ? AND img02 = ? AND img03= ? AND img04= ?",
                       " FOR UPDATE"
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)    #No.FUN-9B0059
    DECLARE img_lock_w CURSOR FROM l_forupd_sql
 
    OPEN img_lock_w USING l_ksd.ksd04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH img_lock_w INTO l_img.*
    IF STATUS THEN
       CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    CASE WHEN p_argv = '1' LET u_type = -1
         WHEN p_argv = '2' LET u_type = +1
    END CASE
   #CALL s_upimg(l_img.rowi,u_type,p_qty*p_factor,g_today,  #FUN-8C0084
    CALL s_upimg(l_ksd.ksd04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,g_today,  #FUN-8C0084
                 '','','','',l_ksd.ksd01,l_ksd.ksd03,   #No.MOD-860261
                 '','','','','','','','','','','','')
    IF g_success='N' THEN RETURN END IF
 
#------------------------------------------- update ima_file
    CALL cl_msg("update ima_file ...")
 
    LET l_forupd_sql = "SELECT ima25,ima86 FROM ima_file ",
                       " WHERE ima01= ?  FOR UPDATE"
    LET l_forupd_sql=cl_forupd_sql(l_forupd_sql)    #No.FUN-9B0059
    DECLARE ima_lock_w CURSOR FROM l_forupd_sql
 
    OPEN ima_lock_w USING l_ksd.ksd04
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    FETCH ima_lock_w INTO l_ima25,l_ima86
    IF STATUS THEN
       CALL cl_err('lock ima fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
    IF l_ksd.ksd08=l_ima25 THEN
       LET l_imafac = 1
    ELSE
       CALL s_umfchk(l_ksd.ksd04,l_ksd.ksd08,l_ima25)
                RETURNING l_cnt,l_imafac
    END IF
    IF cl_null(l_imafac)  THEN
       ###Modify:98/11/15 -----單位無法轉換 -----####
       CALL cl_err('','abm-731',1)
       LET g_success ='N'
       ####LET l_imafac = 1
    END IF
 
    #TQC-C50236--mark--str--
    #LET l_imaqty = p_qty * l_imafac
    #CALL s_udima(l_ksd.ksd04,l_img.img23,l_img.img24,l_imaqty,g_today,u_type)
    #     RETURNING l_cnt
    #IF g_success='N' THEN RETURN END IF
    #TQC-C50236--mark--end--
 
END FUNCTION
 
 
 
 
FUNCTION t622sub_ins_sub_rvv(p_ksc01,p_ksd03,p_argv)
   DEFINE p_ksc01       LIKE ksc_file.ksc01
   DEFINE p_ksd03       LIKE ksd_file.ksd03
   DEFINE p_argv        LIKE type_file.chr1
   DEFINE l_ksc         RECORD LIKE ksc_file.*
   DEFINE l_ksd         RECORD LIKE ksd_file.*
   DEFINE l_pmn		RECORD LIKE pmn_file.*
   DEFINE l_sfb		RECORD LIKE sfb_file.*
   DEFINE l_rva		RECORD LIKE rva_file.*
   DEFINE l_rvb		RECORD LIKE rvb_file.*
   DEFINE l_rvu		RECORD LIKE rvu_file.*
   DEFINE l_rvv		RECORD LIKE rvv_file.*
   DEFINE l_rvvi	RECORD LIKE rvvi_file.*  #No.FUN-7B0018
   DEFINE l_rvbi	RECORD LIKE rvbi_file.*  #No.FUN-7B0018
 
   IF g_success='N' THEN RETURN END IF
   
   SELECT * INTO l_ksc.* FROM ksc_file
    WHERE ksc01 = p_ksc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   
   SELECT * INTO l_ksd.* FROM ksd_file 
    WHERE ksd01 = p_ksc01
      AND ksd03 = p_ksd03
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksd_file',p_ksc01,p_ksd03,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT * INTO l_sfb.* FROM sfb_file
    WHERE sfb01=l_ksd.ksd11
   IF STATUS THEN CALL cl_err('s sfb:',STATUS,1) LET g_success='N' RETURN END IF
 
   IF l_sfb.sfb02<>7 THEN RETURN END IF
 
   SELECT * INTO l_pmn.* FROM pmn_file
    WHERE pmn41=l_ksd.ksd11
      AND pmn65='1'
   IF SQLCA.sqlcode  THEN
      CALL cl_err('s pmn:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
 
   UPDATE pmn_file SET pmn50=l_sfb.sfb09
    WHERE pmn01=l_pmn.pmn01 AND pmn02=l_pmn.pmn02
 
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','pmn_file',l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
 
   #---------------------------------------- insert rva_file (入庫時)
   IF l_ksc.ksc00='1' THEN
      INITIALIZE l_rva.* TO NULL
      LET l_rva.rva01=l_ksc.ksc01
      LET l_rva.rva04='N'
      LET l_rva.rva05=l_sfb.sfb82
      LET l_rva.rva06=l_ksc.ksc02
      LET l_rva.rva10='SUB'
      LET l_rva.rvaconf='Y'
      LET l_rva.rvaacti='Y'
      LET l_rva.rvauser=g_user
      LET g_data_plant = g_plant #FUN-980030
      LET l_rva.rvadate=TODAY
      LET l_rva.rva29=' '     #NO.FUN-960130
      LET l_rva.rvaplant = g_plant #FUN-980008 add
      LET l_rva.rvalegal = g_legal #FUN-980008 add
      LET l_rva.rvaoriu = g_user      #No.FUN-980030 10/01/04
      LET l_rva.rvaorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO rva_file VALUES(l_rva.*)
      #---------------------------------------- insert rvb_file (入庫時)
      INITIALIZE l_rvb.* TO NULL
      LET l_rvb.rvb01=l_ksc.ksc01
      LET l_rvb.rvb02=l_ksd.ksd03
      LET l_rvb.rvb03=l_pmn.pmn02
      LET l_rvb.rvb04=l_pmn.pmn01
      LET l_rvb.rvb05=l_ksd.ksd04
      LET l_rvb.rvb06=0
      LET l_rvb.rvb07=l_ksd.ksd09
      LET l_rvb.rvb08=l_ksd.ksd09
      LET l_rvb.rvb09=l_ksd.ksd09
      LET l_rvb.rvb10=l_pmn.pmn31
      LET l_rvb.rvb18='30'
      LET l_rvb.rvb19='1'
      LET l_rvb.rvb22=l_ksd.ksd12
      LET l_rvb.rvb29=0
      LET l_rvb.rvb30=l_ksd.ksd09
      LET l_rvb.rvb31=0
      LET l_rvb.rvb34=l_ksd.ksd11
      LET l_rvb.rvb35='N'
      LET l_rvb.rvb36=l_ksd.ksd05
      LET l_rvb.rvb37=l_ksd.ksd06
      LET l_rvb.rvb38=l_ksd.ksd07
      LET l_rvb.rvb930=l_ksd.ksd930 #FUN-670103
      LET l_rvb.rvb42 = ' '   #NO.FUN-960130
      LET l_rvb.rvbplant = g_plant #FUN-980008 add
      LET l_rvb.rvblegal = g_legal #FUN-980008 add
      INSERT INTO rvb_file VALUES(l_rvb.*)
      IF STATUS THEN
         CALL cl_err('i rvb:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
      IF NOT s_industry('std') THEN
         #No.FUN-7B0018 080306 add --begin
         INITIALIZE l_rvbi.* TO NULL
         LET l_rvbi.rvbi01 = l_rvb.rvb01
         LET l_rvbi.rvbi02 = l_rvb.rvb02
         IF NOT s_ins_rvbi(l_rvbi.*,'') THEN
            LET g_success = 'N'
            RETURN
         END IF
         #No.FUN-7B0018 080306 add --end
      END IF
   END IF
   #---------------------------------------- insert rvu_file (入/退庫)
   INITIALIZE l_rvu.* TO NULL
   IF l_ksc.ksc00='1' THEN
      LET l_rvu.rvu00='1'
   ELSE
      LET l_rvu.rvu00='3'
   END IF
 
   LET l_rvu.rvu01=l_ksc.ksc01
   LET l_rvu.rvu02=l_ksc.ksc01
   LET l_rvu.rvu03=l_ksc.ksc02
   LET l_rvu.rvu04=l_sfb.sfb82
   SELECT pmc03 INTO l_rvu.rvu05 FROM pmc_file WHERE pmc01=l_rvu.rvu04
   LET l_rvu.rvu08='SUB'
   LET l_rvu.rvuconf='Y'
   LET l_rvu.rvuacti='Y'
   LET l_rvu.rvuuser=g_user
   LET l_rvu.rvudate=TODAY
   #NO.FUN-960130-----begin-----                                                                                                 
   LET l_rvu.rvu21 = ' '                                                                                                         
   LET l_rvu.rvu900 = '0'                                                                                                        
   LET l_rvu.rvumksg = ' '                                                                                                       
   #NO.FUN-960130-----end-----
 
   LET l_rvu.rvuplant = g_plant #FUN-980008 add
   LET l_rvu.rvulegal = g_legal #FUN-980008 add
 
   LET l_rvu.rvuoriu = g_user      #No.FUN-980030 10/01/04
   LET l_rvu.rvuorig = g_grup      #No.FUN-980030 10/01/04
   LET l_rvu.rvu27   = '1'         #TQC-B60065
   INSERT INTO rvu_file VALUES(l_rvu.*)
   #---------------------------------------- insert rvv_file (入/退庫)
   INITIALIZE l_rvv.* TO NULL
   LET l_rvv.rvv01=l_ksc.ksc01
   LET l_rvv.rvv02=l_ksd.ksd03
   IF l_ksc.ksc00='1' THEN
      LET l_rvv.rvv03='1'
   ELSE
      LET l_rvv.rvv03='3'
   END IF
   LET l_rvv.rvv04=l_ksc.ksc01
   LET l_rvv.rvv05=l_ksd.ksd03
   LET l_rvv.rvv06=l_sfb.sfb82
   LET l_rvv.rvv09=l_ksc.ksc02
   LET l_rvv.rvv17=l_ksd.ksd09
   LET l_rvv.rvv18=l_ksd.ksd11
   LET l_rvv.rvv23=0
   LET l_rvv.rvv88=0           #No.TQC-7B0083
   LET l_rvv.rvv25='N'
   LET l_rvv.rvv31=l_ksd.ksd04
   SELECT ima02 INTO l_rvv.rvv031 FROM ima_file WHERE ima01=l_ksd.ksd04
   LET l_rvv.rvv32=l_ksd.ksd05
   LET l_rvv.rvv33=l_ksd.ksd06
   LET l_rvv.rvv34=l_ksd.ksd07
   LET l_rvv.rvv35=l_ksd.ksd08
   LET l_rvv.rvv35_fac=1
   LET l_rvv.rvv36=l_pmn.pmn01
   LET l_rvv.rvv37=l_pmn.pmn02
   LET l_rvv.rvv930=l_ksd.ksd930 #FUN-670103
   IF cl_null(l_rvv.rvv02) THEN LET l_rvv.rvv02 = 1 END IF  
   LET l_rvv.rvv10 = ' '    #NO.FUN-960130
 
   LET l_rvv.rvvplant = g_plant #FUN-980008 add
   LET l_rvv.rvvlegal = g_legal #FUN-980008 add
   #流通代銷無收貨單,將發票記錄rvb22同時新增到rvv22內
   LET l_rvv.rvv22 = l_rvb.rvb22  #FUN-BB0001 add 
   INSERT INTO rvv_file VALUES(l_rvv.*)
   IF STATUS THEN CALL cl_err('i rvv:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
   IF NOT s_industry('std') THEN
      #No.FUN-7B0018 080306 add --begin
      INITIALIZE l_rvvi.* TO NULL
      LET l_rvvi.rvvi01 = l_rvv.rvv01
      LET l_rvvi.rvvi02 = l_rvv.rvv02
      IF NOT s_ins_rvvi(l_rvvi.*,'') THEN
         LET g_success = 'N'
         RETURN
      END IF
      #No.FUN-7B0018 080306 add --end
   END IF
 
END FUNCTION
 
FUNCTION t622sub_w(p_ksc01,p_action_choice,p_inTransaction,p_argv)       #過帳還原
   DEFINE p_ksc01            LIKE ksc_file.ksc01
   DEFINE p_action_choice    STRING
   DEFINE p_inTransaction  LIKE type_file.num5 
   DEFINE p_argv             LIKE type_file.chr1
   DEFINE l_ksc              RECORD LIKE ksc_file.* 
   DEFINE l_ksd              RECORD LIKE ksd_file.* 
   DEFINE l_yy               LIKE type_file.num10
   DEFINE l_mm               LIKE type_file.num10
   DEFINE l_imm01            LIKE imm_file.imm01
   DEFINE l_msg              STRING
   DEFINE l_ima906           LIKE ima_file.ima906
 
   LET g_success = 'Y'   #TQC-C50236 add

   IF s_shut(0) THEN RETURN END IF
   IF g_success='N' THEN RETURN END IF
   
   #LET g_success = 'Y'  #TQC-C50236 mark
 
   IF p_ksc01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N' 
      RETURN 
   END IF   
   
   SELECT * INTO l_ksc.* FROM ksc_file
    WHERE ksc01 = p_ksc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
   
   IF l_ksc.kscpost='N' THEN 
      CALL cl_err(l_ksc.ksc01,'mfg0178',1)
      LET g_success = 'N'
      RETURN 
   END IF
 
   IF l_ksc.kscconf = 'X' THEN 
      CALL cl_err('','9024',0) 
      LET g_success = 'N'
      RETURN 
   END IF #FUN-660137

#FUN-D30065 ----------Begin-------------		
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原 		
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'		
   IF g_ccz.ccz28  = '6' THEN		
      CALL cl_err('','apm-936',1)		
      LET g_success = 'N'
      RETURN		
   END IF 		
#FUN-D30065 ----------End---------------		

   IF g_sma.sma53 IS NOT NULL AND l_ksc.ksc02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL s_yp(l_ksc.ksc02) RETURNING l_yy,l_mm
   IF (l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(l_yy,'mfg6090',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF NOT cl_null(p_action_choice) THEN
      IF NOT cl_confirm('asf-663') THEN RETURN END IF
   END IF
 
   IF NOT p_inTransaction THEN   
      BEGIN WORK    #carrier
   END IF
 
   CALL t622sub_lock_cl() 
   OPEN t622sub_cl USING p_ksc01
   IF STATUS THEN
      CALL cl_err("OPEN t622sub_cl:", STATUS, 1)
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   FETCH t622sub_cl INTO l_ksc.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err('lock ksc:',SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t622sub_cl
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
      LET g_success='N' #FUN-730012 add
      RETURN
   END IF
 
   CLOSE t622sub_cl
 
 
   UPDATE ksc_file SET kscpost='N' WHERE ksc01=l_ksc.ksc01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3('upd','ksc_file',l_ksc.ksc01,'',SQLCA.sqlcode,'','','1')
      LET g_success='N'
   END IF
 
   CALL t622sub_w1(l_ksc.ksc01,p_argv)
 
   IF g_success = 'Y' THEN
      LET l_ksc.kscpost='N'
      IF NOT p_inTransaction THEN COMMIT WORK END IF
   ELSE
      LET l_ksc.kscpost='Y'
      IF NOT p_inTransaction THEN ROLLBACK WORK END IF
   END IF
 
 
   #-----No.FUN-610090-----
   IF l_ksc.kscpost = "Y" THEN
      DECLARE t622sub_s1_c2 CURSOR FOR SELECT * FROM ksd_file
        WHERE ksd01 = l_ksc.ksc01
 
      LET l_imm01 = ""
      LET g_success = "Y"
 
      CALL s_showmsg_init()   #No.FUN-6C0083 
 
      BEGIN WORK
 
      FOREACH t622sub_s1_c2 INTO l_ksd.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
         
         SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = l_ksd.ksd04
 
         IF g_sma.sma115 = 'Y' THEN
            IF l_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= l_ksd.ksd30
               LET g_unit_arr[1].fac = l_ksd.ksd31
               LET g_unit_arr[1].qty = l_ksd.ksd32
               LET g_unit_arr[2].unit= l_ksd.ksd33
               LET g_unit_arr[2].fac = l_ksd.ksd34
               LET g_unit_arr[2].qty = l_ksd.ksd35
               CALL s_dismantle(l_ksc.ksc01,l_ksd.ksd03,l_ksc.ksc02,
                                l_ksd.ksd04,l_ksd.ksd05,l_ksd.ksd06,
                                l_ksd.ksd07,g_unit_arr,l_imm01)
                      RETURNING l_imm01
               #TQC-620156...............begin
               IF g_success='N' THEN 
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH   #No.FUN-6C0083
                  #RETURN 
               END IF
               #TQC-620156...............end
            END IF
         END IF
      END FOREACH
 
      #TQC-620156...............begin
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
 
      CALL s_showmsg()   #No.FUN-6C0083
 
      #TQC-620156...............end
 
      IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
         COMMIT WORK
         LET l_msg="aimt324 '",l_imm01,"'"
         CALL cl_cmdrun_wait(l_msg)
      ELSE
         ROLLBACK WORK
      END IF
   END IF
   #-----No.FUN-610090 END-----
 
END FUNCTION
 
FUNCTION t622sub_w1(p_ksc01,p_argv)
 DEFINE p_ksc01     LIKE ksc_file.ksc01
 DEFINE p_argv      LIKE type_file.chr1
 DEFINE l_ksd       RECORD LIKE ksd_file.*
 DEFINE l_ksc       RECORD LIKE ksc_file.*
 DEFINE l_sfb       RECORD LIKE sfb_file.*
 DEFINE l_ksd091    LIKE ksd_file.ksd09
 DEFINE l_ksd092    LIKE ksd_file.ksd09
 DEFINE l_ksd09     LIKE ksd_file.ksd09
 DEFINE l_qcf091    LIKE qcf_file.qcf091
 DEFINE s_ksd09     LIKE ksd_file.ksd09
 DEFINE l_sfb04     LIKE sfb_file.sfb04
 DEFINE l_sfb39     LIKE sfb_file.sfb39
 DEFINE l_flag      LIKE type_file.num5 
 DEFINE l_ima918    LIKE ima_file.ima918
 DEFINE l_ima921    LIKE ima_file.ima921
 DEFINE l_cnt       LIKE type_file.num5
 DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
 DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
 DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
   IF g_success = 'N' THEN RETURN END IF
  
   IF p_ksc01 IS NULL THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N' 
      RETURN 
   END IF   
   
   SELECT * INTO l_ksc.* FROM ksc_file
    WHERE ksc01 = p_ksc01
   IF SQLCA.sqlcode THEN
      CALL cl_err3('sel','ksc_file',p_ksc01,'',SQLCA.sqlcode,'','','1')
      LET g_success = 'N'
      RETURN
   END IF
  
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE t622sub_w1_c CURSOR FOR
   SELECT * FROM ksd_file WHERE ksd01=l_ksc.ksc01
 
  FOREACH t622sub_w1_c INTO l_ksd.*
      IF STATUS THEN EXIT FOREACH END IF
      MESSAGE '_s1() read ksd:',l_ksd.ksd03
    #No.B363
     SELECT sfb04 INTO l_sfb04 FROM sfb_file WHERE sfb01=l_ksd.ksd11
     IF l_sfb04='8' THEN
        CALL cl_err(l_ksd.ksd01,'mfg3430',1)
        LET g_success='N'
        EXIT FOREACH
     END IF
    #No.B363 END
 
      IF l_ksd.ksd09 = 0 THEN
         CALL cl_err(l_ksd.ksd09,'asf-660',0)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
 
      IF cl_null(l_ksd.ksd04) THEN CONTINUE FOREACH END IF
 
      #-----更新sfb_file-----------
      IF p_argv = '1' OR p_argv = '2' THEN
         LET l_ksd091 = 0    LET l_ksd092 = 0  LET l_ksd09 = 0
         SELECT SUM(ksd09) INTO l_ksd091 FROM ksc_file,ksd_file
          WHERE ksd11 = l_ksd.ksd11
            AND ksc01 = ksd01
              AND ksd04 = l_ksd.ksd04
            AND ksc00 = '1'  #入庫
            AND kscpost = 'Y'
         SELECT SUM(ksd09) INTO l_ksd092 FROM ksc_file,ksd_file
          WHERE ksd11 = l_ksd.ksd11
            AND ksc01 = ksd01
              AND ksd04 = l_ksd.ksd04
            AND ksc00 = '2'  #退回
            AND kscpost = 'Y'
         IF cl_null(l_ksd091) THEN LET l_ksd091 = 0 END IF
         IF cl_null(l_ksd092) THEN LET l_ksd092 = 0 END IF
         LET l_ksd09 = l_ksd091 - l_ksd092
      END IF
 
     #IF l_ksc.ksc03 IS NOT NULL THEN   #CHI-950036
      IF l_ksd.ksd17 IS NOT NULL THEN   #CHI-950036
         SELECT SUM(ksd09) INTO s_ksd09
           FROM ksc_file,ksd_file
         #WHERE ksc03 = l_ksc.ksc03     #CHI-950036
          WHERE ksd17 = l_ksd.ksd17     #CHI-950036
            AND ksd11 = l_ksd.ksd11
            AND ksd04 = l_ksd.ksd04
            AND ksc01 = ksd01
            AND kscpost = 'Y' AND ksc00='1'
         IF s_ksd09 IS NULL THEN LET s_ksd09 = 0 END IF
 
      END IF
 
      IF p_argv = '1' OR p_argv = '2' THEN
 
         #No.FUN-540055  --begin
         IF g_sma.sma115 = 'Y' THEN
            IF l_ksd.ksd32 != 0 OR l_ksd.ksd35 != 0 THEN
               CALL t622sub_update_du('w',p_argv,l_ksc.ksc01,l_ksd.ksd03)
               IF g_success='N' THEN 
                  #TQC-620156...............begin
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH   #No.FUN-6C0083
                  #RETURN 
                  #TQC-620156...............end
               END IF
            END IF
         END IF
         #No.FUN-540055  --end
         IF l_ksd.ksd09 != 0 THEN
         CALL t622sub_update_w(l_ksc.ksc01,l_ksd.ksd03,p_argv)
         END IF
         IF g_success='N' THEN 
            #TQC-620156...............begin
            LET g_totsuccess='N'
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
            #RETURN 
            #TQC-620156...............end
         END IF
      END IF
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         " WHERE tlf01 = '",l_ksd.ksd04,"' ", 
                         "   AND tlf026 = '",l_ksd.ksd01,"' AND tlf027= ",l_ksd.ksd01," "
            DECLARE t622_u_tlf_c CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t622_u_tlf_c INTO g_tlf.*  
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 

      DELETE FROM tlf_file
       WHERE tlf01 =l_ksd.ksd04
         AND tlf026=l_ksd.ksd01
         AND tlf027=l_ksd.ksd03
      IF SQLCA.SQLCODE THEN
#        CALL cl_err('del tlf',SQLCA.SQLCODE,0)  #No.FUN-660128
         CALL cl_err3("del","tlf_file","","",SQLCA.SQLCODE,"","del tlf",1)  #No.FUN-660128
           LET g_success = 'N' RETURN   
      END IF
    ##NO.FUN-8C0131   add--begin
      FOR l_i = 1 TO la_tlf.getlength()
         LET g_tlf.* = la_tlf[l_i].*
         IF NOT s_untlf1('') THEN 
            LET g_success='N' RETURN
         END IF 
      END FOR       
  ##NO.FUN-8C0131   add--end 
 
      SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
       WHERE ima01 = l_ksd.ksd04
     IF l_ima918 = "Y" OR l_ima921 = "Y" THEN  #MOD-8C0058 add
        #-----No.FUN-810036-----
        DELETE FROM tlfs_file
         WHERE tlfs01 = l_ksd.ksd04
           AND tlfs10 = l_ksd.ksd01
           AND tlfs11 = l_ksd.ksd03
     
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err('del tlfs',STATUS,0)
           LET g_success = 'N'
           RETURN
        END IF
        #-----No.FUN-810036 END-----
     END IF                                    #MOD-8C0058 add
 
      #判斷工單狀態若已無入庫資料則更新為發料
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt
        FROM ksc_file,ksd_file
        WHERE ksd11 = l_ksd.ksd11
          AND ksc01 = ksd01
          AND ksc00 = '1'           #完工入庫
          AND kscpost = 'Y'
      IF l_cnt=0 OR l_cnt IS NULL THEN
        #FUN-5C0055...............begin
         LET l_sfb39=''
         SELECT sfb39 INTO l_sfb39 FROM sfb_file
          #WHERE sfb01=b_sfv.sfv11 #MOD-950221
           WHERE sfb01=l_ksd.ksd11 #MOD-950221 
         IF cl_null(l_sfb39) OR (l_sfb39='1') THEN
           UPDATE sfb_file
              SET sfb04='4'
            WHERE sfb01=l_ksd.ksd11
         ELSE
           UPDATE sfb_file
              SET sfb04='2'
            WHERE sfb01=l_ksd.ksd11
         END IF
        #FUN-5C0055...............end
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('upd sfb04:',SQLCA.SQLCODE,0)                                  #TQC-C50236 mark
            CALL cl_err3("upd","sfb_file",l_ksd.ksd11,"",SQLCA.sqlcode,"","upd sfb",1)  #TQC-C50236 add
            LET g_success='N'
            RETURN
         END IF
      END IF
 
  END FOREACH
  #TQC-620156...............begin
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
 
  CALL s_showmsg()   #No.FUN-6C0083
  #TQC-620156...............end
END FUNCTION
 
