/*
================================================================================
檔案代號:cah_file
檔案名稱:工单下线资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cah_file
(
cah01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
cah02       number(5) NOT NULL,      /*年度                                   */
cah03       number(5) NOT NULL,      /*月份                                   */
cah04       varchar2(40) NOT NULL,   /*下线料件编号                           */
                                     /*下線料件編號                           */
                                     /*需存在在料件基本資料主檔               */
                                     /*為該工單下線料件編號                   */
cah05       number(5) NOT NULL,      /*下线之工艺序号                         */
                                     /*下線之製程序號                         */
                                     /*料件被製作程序過程中的生產活動順序編號 */
cah06       varchar2(6) NOT NULL,    /*下线之作业编号                         */
                                     /*下線之作業編號                         */
                                     /*料件被製作程序過程中的生產活動編號     */
cah07       number(15,3),            /*下线数量         (+)                   */
                                     /*下線數量         (+)                   */
cah08       number(20,6),            /*下线金额         (+)                   */
                                     /*下線金額         (+)                   */
cah08a      number(20,6),            /*下线材料成本     (+)                   */
                                     /*下線材料成本     (+)                   */
cah08b      number(20,6),            /*下线人工成本     (+)                   */
                                     /*下線人工成本     (+)                   */
cah08c      number(20,6),            /*下线制造费用     (+)                   */
                                     /*下線製造費用     (+)                   */
cah08d      number(20,6),            /*下线加工费用     (+)                   */
                                     /*下線加工費用     (+)                   */
cah08e      number(20,6),            /*下线其它成本     (+)                   */
                                     /*下線其它成本     (+)                   */
cah08f      number(20,6) DEFAULT '0',/*下线制造费用三     (+)                 */
cah08g      number(20,6) DEFAULT '0',/*下线制造费用四     (+)                 */
cah08h      number(20,6) DEFAULT '0',/*下线制造费用五     (+)                 */
cahlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cah012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table cah_file add  constraint cah_pk primary key  (cah01,cah02,cah03,cah04,cah05,cah06,cah012) enable validate;
grant select on cah_file to tiptopgp;
grant update on cah_file to tiptopgp;
grant delete on cah_file to tiptopgp;
grant insert on cah_file to tiptopgp;
grant index on cah_file to public;
grant select on cah_file to ods;
