/*
================================================================================
檔案代號:nsb_file
檔案名稱:转账媒体结构单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nsb_file
(
nsb01       varchar2(10) DEFAULT ' ' NOT NULL, /*媒体编号*/
nsb02       number(5) DEFAULT '0' NOT NULL, /*序号*/
nsb03       varchar2(1),             /*区分码                                 */
nsb04       varchar2(2),             /*区分码                                 */
nsb05       varchar2(15),            /*档案编号                               */
nsb06       varchar2(20),            /*字段编号                               */
nsb07       varchar2(80),            /*字段名称                               */
nsb08       varchar2(1),             /*字段类型                               */
nsb09       number(15,3),            /*固定数值                               */
nsb10       varchar2(40),            /*固定文字                               */
nsb11       varchar2(1),             /*合计阶1                                */
nsb12       varchar2(1),             /*合计阶2                                */
nsb13       varchar2(1),             /*合计阶3                                */
nsb14       varchar2(1),             /*合计阶4                                */
nsb15       varchar2(1),             /*合计阶5                                */
nsb16       number(5),               /*转出长度                               */
nsb17       varchar2(255),           /*备注                                   */
nsb18       number(5),               /*小数位数                               */
nsb19       varchar2(1),             /*填空方式                               */
nsb20       varchar2(1),             /*字段可空白                             */
nsb21       varchar2(1),             /*含小数点                               */
nsb22       varchar2(1),             /*字串相接                               */
nsb23       varchar2(1) DEFAULT '1' NOT NULL /*半形/全形*/
);

alter table nsb_file add  constraint nsb_pk primary key  (nsb01,nsb02) enable validate;
grant select on nsb_file to tiptopgp;
grant update on nsb_file to tiptopgp;
grant delete on nsb_file to tiptopgp;
grant insert on nsb_file to tiptopgp;
grant index on nsb_file to public;
grant select on nsb_file to ods;
