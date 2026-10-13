/*
================================================================================
檔案代號:ocg_file
檔案名稱:销售系统信用检查参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table ocg_file
(
ocg01       varchar2(10) NOT NULL,   /*信用评等                               */
ocg02       number(5),               /*待抵帐款金额检查比率                   */
ocg03       number(5),               /*ｌｃ收状金额检查比率                   */
ocg04       number(5),               /*暂收支票ｔｔ检查比率                   */
ocg05       number(5),               /*已冲帐未审核检查比率                   */
ocg06       number(5),               /*未兑应收票据检查比率                   */
ocg07       number(5),               /*发票应收帐款检查比率                   */
ocg08       number(5),               /*出货未开发票检查比率                   */
ocg09       number(5),               /*出货通知单检查比率                     */
ocg10       number(5),               /*接单未出货额检查比率                   */
ocg11       varchar2(1),             /*检查over due否                         */
ocg12       varchar2(1),             /*检查逾期未兑现票据否                   */
ocgacti     varchar2(1),             /*资料有效码                             */
ocguser     varchar2(10),            /*资料所有者                             */
ocggrup     varchar2(10),            /*资料所有部门                           */
ocgmodu     varchar2(10),            /*资料更改者                             */
ocgdate     date,                    /*最近更改日                             */
ocgorig     varchar2(10),            /*资料建立部门                           */
ocgoriu     varchar2(10)             /*资料建立者                             */
);

alter table ocg_file add  constraint ocg_pk primary key  (ocg01) enable validate;
grant select on ocg_file to tiptopgp;
grant update on ocg_file to tiptopgp;
grant delete on ocg_file to tiptopgp;
grant insert on ocg_file to tiptopgp;
grant index on ocg_file to public;
grant select on ocg_file to ods;
