/*
================================================================================
檔案代號:zax_file
檔案名稱:CR认证记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zax_file
(
zax01       number(5) NOT NULL,      /*认证码                                 */
zax02       varchar2(10) NOT NULL,   /*用户                                   */
zax03       varchar2(255) DEFAULT '1' NOT NULL, /*CR报表位置*/
zax04       varchar2(1000) DEFAULT '1' NOT NULL, /*CR报表SQL*/
zax05       varchar2(1000) DEFAULT '1' NOT NULL, /*CR报表参数1*/
zax06       varchar2(1000),          /*CR报表参数2                            */
zax07       varchar2(1000),          /*CR报表参数3                            */
zax08       varchar2(1) DEFAULT '1' NOT NULL, /*简繁转换*/
zax09       varchar2(255) DEFAULT '1' NOT NULL, /*LOGO位置*/
zax10       varchar2(500),           /*暂存档名                               */
zax11       varchar2(20),            /*用户允许印表方式                       */
zax12       varchar2(1500),          /*子报表SQL1                             */
zax13       varchar2(1500),          /*子报表SQL2                             */
zax14       varchar2(1500),          /*子报表SQL3                             */
zax15       varchar2(1500),          /*子报表SQL4                             */
zax16       varchar2(1500),          /*子报表SQL5                             */
zax17       varchar2(1500),          /*子报表SQL                              */
zax18       varchar2(1500),          /*子报表SQL                              */
zax19       varchar2(1500),          /*子报表SQL                              */
zax20       varchar2(1500),          /*子报表SQL                              */
zax21       varchar2(1500),          /*子报表SQL                              */
zax22       varchar2(1500),          /*子报表SQL                              */
zax23       varchar2(1500),          /*子报表SQL                              */
zax24       varchar2(1500),          /*子报表SQL                              */
zax25       varchar2(1500),          /*子报表SQL                              */
zax26       varchar2(1500),          /*子报表SQL                              */
zax27       number(10),              /*Time Out Setting                       */
zax28       varchar2(120),           /*报表主档资讯                           */
zax29       varchar2(1000),          /*收件者                                 */
zax30       varchar2(1000),          /*副本                                   */
zax31       varchar2(1000),          /*密件副本                               */
zax32       varchar2(1000),          /*邮件本文                               */
zax33       varchar2(80),            /*寄件者                                 */
zax34       varchar2(255),           /*报表档名                               */
zax35       varchar2(1) DEFAULT 'Y' NOT NULL, /*档名重复时覆写*/
zax36       varchar2(1),             /*NO USE
                                                                                */
zax37       varchar2(30),            /*纸张名称                               */
zax38       varchar2(1),             /*纸张方向(P:纵向/L:横向)                */
zax39       varchar2(8),             /*no use
                                                                                */
zax40       varchar2(1500),          /*no use                                 */
zax41       varchar2(30) DEFAULT ' ' NOT NULL,
zax42       varchar2(255)
);

alter table zax_file add  constraint zax_pk primary key  (zax01,zax41) enable validate;
grant select on zax_file to tiptopgp;
grant update on zax_file to tiptopgp;
grant delete on zax_file to tiptopgp;
grant insert on zax_file to tiptopgp;
grant index on zax_file to public;
grant select on zax_file to ods;
