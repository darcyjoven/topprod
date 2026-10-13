/*
================================================================================
檔案代號:axi_file
檔案名稱:调整与销除分录底稿单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table axi_file
(
axi00       varchar2(5) NOT NULL,    /*帐套                                   */
axi01       varchar2(20) NOT NULL,   /*凭证编号                               */
axi02       date,                    /*单据日期                               */
axi03       number(5),               /*调整年度                               */
axi04       number(5),               /*调整月份                               */
axi05       varchar2(10),            /*集团代号                               */
axi06       varchar2(10),            /*母公司编号                             */
axi07       varchar2(5),             /*母公司账套                             */
axi08       varchar2(1),             /*来源码                                 */
axi09       varchar2(1),             /*换汇差额调整否                         */
axi10       varchar2(255),           /*备注                                   */
axi11       number(20,6),            /*借方总金额                             */
axi12       number(20,6),            /*贷方总金额                             */
axi13       varchar2(20),            /*确认时自动产生单据编号                 */
axi14       varchar2(1),             /*No Use                                 */
axi15       varchar2(1),             /*No Use                                 */
axi16       varchar2(1),             /*No Use                                 */
axi17       varchar2(1),             /*No Use                                 */
axi18       varchar2(1),             /*No Use                                 */
axi19       varchar2(1),             /*No Use                                 */
axi20       varchar2(1),             /*No Use                                 */
axiconf     varchar2(1),             /*确认码                                 */
axiuser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
axigrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
aximodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
axidate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
axi21       varchar2(10),            /*版本                                   */
axilegal    varchar2(10) NOT NULL,   /*所属法人                               */
axioriu     varchar2(10),            /*资料建立者                             */
axiorig     varchar2(10),            /*资料建立部门                           */
axi081      varchar2(1) DEFAULT '1' NOT NULL /*冲销类型*/
);

create        index axi_02 on axi_file (axi02);
alter table axi_file add  constraint axi_pk primary key  (axi01,axi00) enable validate;
grant select on axi_file to tiptopgp;
grant update on axi_file to tiptopgp;
grant delete on axi_file to tiptopgp;
grant insert on axi_file to tiptopgp;
grant index on axi_file to public;
grant select on axi_file to ods;
