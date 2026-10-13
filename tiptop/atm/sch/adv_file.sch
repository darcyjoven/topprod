/*
================================================================================
檔案代號:adv_file
檔案名稱:分销系统参数档-收货单
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table adv_file
(
adv01       varchar2(10) NOT NULL,   /*拨入营运中心                           */
adv02       varchar2(5),             /*出货单别                               */
adv03       varchar2(10),            /*销售分类                               */
adv04       varchar2(10),            /*业务员                                 */
adv05       varchar2(10),            /*出货部门                               */
adv06       varchar2(4),             /*税种                                   */
adv07       number(9,4),             /*税率                                   */
adv08       varchar2(1),             /*联数                                   */
adv09       varchar2(1),             /*含税否                                 */
adv10       varchar2(4),             /*币种                                   */
adv11       number(20,10),           /*汇率                                   */
adv12       varchar2(5),             /*发票别                                 */
adv13       varchar2(10),            /*科目别                                 */
adv14       varchar2(1),             /*No                                     */
adv15       varchar2(1),             /*No                                     */
advacti     varchar2(1),             /*资料有效码                             */
advuser     varchar2(10),            /*资料所有者                             */
advgrup     varchar2(10),            /*资料所有部门                           */
advmodu     varchar2(10),            /*资料更改者                             */
advdate     date,                    /*最近更改日                             */
advorig     varchar2(10),            /*资料建立部门                           */
advoriu     varchar2(10)             /*资料建立者                             */
);

alter table adv_file add  constraint adv_pk primary key  (adv01) enable validate;
grant select on adv_file to tiptopgp;
grant update on adv_file to tiptopgp;
grant delete on adv_file to tiptopgp;
grant insert on adv_file to tiptopgp;
grant index on adv_file to public;
grant select on adv_file to ods;
