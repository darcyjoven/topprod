/*
================================================================================
檔案代號:cnt_file
檔案名稱:新贸加工合同核销单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnt_file
(
cnt01       varchar2(20) NOT NULL,   /*核销单号                               */
cnt02       number(5) NOT NULL,      /*合同序号                               */
cnt03       varchar2(40),            /*商品编号                               */
cnt04       varchar2(1),             /*No Use                                 */
cnt05       number(15,3),            /*进口总数                               */
cnt051      number(15,3),            /*成品折算数                             */
cnt06       number(15,3),            /*上个合同转入数量                       */
cnt061      number(15,3),            /*转厂货物转入数量                       */
cnt062      number(15,3),            /*本合同进口数量                         */
cnt07       number(15,3),            /*成品耗量                               */
cnt08       number(15,3),            /*退港原料或废料量                       */
cnt09       number(15,3),            /*内销或处理量                           */
cnt10       number(15,3),            /*剩余原物料数量                         */
cnt11       number(20,6),            /*剩余原物料价格                         */
cntplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cntlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cnt_file add  constraint cnt_pk primary key  (cnt01,cnt02) enable validate;
grant select on cnt_file to tiptopgp;
grant update on cnt_file to tiptopgp;
grant delete on cnt_file to tiptopgp;
grant insert on cnt_file to tiptopgp;
grant index on cnt_file to public;
grant select on cnt_file to ods;
