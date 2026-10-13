/*
================================================================================
檔案代號:oeo_file
檔案名稱:订单产品的选择配件(Options)/备品档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeo_file
(
oeo01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號                               */
oeo03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oeo04       varchar2(40) NOT NULL,   /*选择配件料号                           */
                                     /*選擇配件料號                           */
oeo05       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
oeo06       number(20,8) NOT NULL,   /*QPA                                    */
                                     /*QPA                #No:6102            */
oeo07       varchar2(1),             /*必需否                                 */
                                     /*必需否 (0.必需件 1.選擇配件)           */
oeo08       varchar2(1),             /*属性                                   */
                                     /*屬性 1.選配件  2.備品 #by payton       */
oeo09       number(15,3),            /*数量                                   */
                                     /*數量                  #by payton       */
oeoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oeo_file add  constraint oeo_pk primary key  (oeo01,oeo03,oeo04) enable validate;
grant select on oeo_file to tiptopgp;
grant update on oeo_file to tiptopgp;
grant delete on oeo_file to tiptopgp;
grant insert on oeo_file to tiptopgp;
grant index on oeo_file to public;
grant select on oeo_file to ods;
