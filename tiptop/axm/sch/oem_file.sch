/*
================================================================================
檔案代號:oem_file
檔案名稱:订单/出货单身更改记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table oem_file
(
oem01       varchar2(20),            /*订单/出货单号                          */
                                     /*訂單/出貨單號                          */
oem03       number(5),               /*项次                                   */
                                     /*項次                                   */
oem04       date,                    /*更改日期                               */
                                     /*修改日期                               */
oem05       varchar2(5),             /*更改时间                               */
                                     /*修改時間                               */
oem06       varchar2(10),            /*更改人员                               */
                                     /*修改人員                               */
oem07       varchar2(1),             /*动作                                   */
                                     /*動作 (A.新增 U.修改 R.刪除)            */
oem08       varchar2(10),            /*更改版本                               */
                                     /*修改版本                               */
oem10o      varchar2(40),            /*原料号                                 */
                                     /*原料號                                 */
oem10n      varchar2(40),            /*新料号                                 */
                                     /*新料號                                 */
oem11o      varchar2(24),            /*原批号                                 */
                                     /*原批號 No.+024                         */
oem11n      varchar2(24),            /*新批号                                 */
                                     /*新批號 No.+024                         */
oem12o      number(15,3),            /*原数量                                 */
                                     /*原數量                                 */
oem12n      number(15,3),            /*新数量                                 */
                                     /*新數量                                 */
oem13o      number(20,6),            /*原单价                                 */
                                     /*原單價                                 */
oem13n      number(20,6),            /*新单价                                 */
                                     /*新單價                                 */
oem15o      date,                    /*原预定交货日                           */
                                     /*原預定交貨日                           */
oem15n      date,                    /*新预定交货日                           */
                                     /*新預定交貨日                           */
oemplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oemlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index oem_01 on oem_file (oem01);
grant select on oem_file to tiptopgp;
grant update on oem_file to tiptopgp;
grant delete on oem_file to tiptopgp;
grant insert on oem_file to tiptopgp;
grant index on oem_file to public;
grant select on oem_file to ods;
