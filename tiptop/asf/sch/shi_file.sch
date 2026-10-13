/*
================================================================================
檔案代號:shi_file
檔案名稱:工单生产日报维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table shi_file
(
shi01       varchar2(20) NOT NULL,   /*移转单号                               */
                                     /*移轉單號                               */
shi02       varchar2(20) NOT NULL,   /*转入工单编号                           */
                                     /*轉入工單編號                           */
shi03       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
shi04       number(5) NOT NULL,      /*工艺序                                 */
                                     /*製程序                                 */
shi05       number(15,3),            /*转入数量                               */
                                     /*轉入數量                               */
shi06       varchar2(1),             /*No Use                                 */
shi07       varchar2(1),             /*No Use                                 */
shi08       varchar2(1),             /*No Use                                 */
shi09       varchar2(1),             /*No Use                                 */
shi10       varchar2(1),             /*No Use                                 */
shiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
shilegal    varchar2(10) NOT NULL,   /*所属法人                               */
shi012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table shi_file add  constraint shi_pk primary key  (shi01,shi02,shi04,shi012) enable validate;
grant select on shi_file to tiptopgp;
grant update on shi_file to tiptopgp;
grant delete on shi_file to tiptopgp;
grant insert on shi_file to tiptopgp;
grant index on shi_file to public;
grant select on shi_file to ods;
