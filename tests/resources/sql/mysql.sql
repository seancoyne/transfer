-- MySQL dump 10.11
--
-- Host: localhost    Database: transfer_unit
-- ------------------------------------------------------
-- Server version	5.0.51a-3ubuntu5.4

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `lnk_composite1`
--

DROP TABLE IF EXISTS `lnk_composite1`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `lnk_composite1` (
  `lnkidbasic` int(11) NOT NULL,
  `lnkidcomposite` varchar(200) NOT NULL,
  KEY `fk_comp_1` (`lnkidcomposite`),
  KEY `fk_comp_2` (`lnkidbasic`),
  CONSTRAINT `fk_comp_1` FOREIGN KEY (`lnkidcomposite`) REFERENCES `tbl_composite` (`idcomposite`),
  CONSTRAINT `fk_comp_2` FOREIGN KEY (`lnkidbasic`) REFERENCES `tbl_onetomany` (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `lnk_manytomany2uuid`
--

DROP TABLE IF EXISTS `lnk_manytomany2uuid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `lnk_manytomany2uuid` (
  `lnkidmanytomany` varchar(200) NOT NULL,
  `lnkidbasic` varchar(200) NOT NULL,
  KEY `fk_m2m2_1` (`lnkidmanytomany`),
  KEY `fk_m2m2_2` (`lnkidbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `lnk_manytomanyuuid`
--

DROP TABLE IF EXISTS `lnk_manytomanyuuid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `lnk_manytomanyuuid` (
  `lnkidmanytomany` varchar(200) NOT NULL,
  `lnkidbasic` varchar(200) NOT NULL,
  KEY `fk_m2m_1` (`lnkidmanytomany`),
  KEY `fk_m2m_2` (`lnkidbasic`),
  CONSTRAINT `fk_m2m_1` FOREIGN KEY (`lnkidmanytomany`) REFERENCES `tbl_manytomanyuuid` (`idsimple`),
  CONSTRAINT `fk_m2m_2` FOREIGN KEY (`lnkidbasic`) REFERENCES `tbl_basicuuid` (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_a`
--

DROP TABLE IF EXISTS `tbl_a`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_a` (
  `a_id` varchar(200) NOT NULL,
  `lnkid` varchar(200) default NULL,
  `lnkid2` varchar(200) default NULL,
  `a_value` varchar(200) default NULL,
  PRIMARY KEY  (`a_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_ap`
--

DROP TABLE IF EXISTS `tbl_ap`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_ap` (
  `ap_id` varchar(200) NOT NULL,
  `a_id` varchar(200) default NULL,
  `stringvalue` varchar(200) default NULL,
  PRIMARY KEY  (`ap_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_b`
--

DROP TABLE IF EXISTS `tbl_b`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_b` (
  `b_id` varchar(200) NOT NULL,
  `lnkid` varchar(200) default NULL,
  `lnkid2` varchar(200) default NULL,
  `b_value` varchar(200) default NULL,
  PRIMARY KEY  (`b_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_basic`
--

DROP TABLE IF EXISTS `tbl_basic`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_basic` (
  `idbasic` decimal(18,0) NOT NULL,
  `basic_date` datetime default NULL,
  `basic_numeric` decimal(18,0) default NULL,
  `basic_string` varchar(200) default NULL,
  `basic_uuid` varchar(200) default NULL,
  `basic_boolean` bit(1) default NULL,
  `basic_decimal` decimal(18,5) default NULL,
  PRIMARY KEY  (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_basicguid`
--

DROP TABLE IF EXISTS `tbl_basicguid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_basicguid` (
  `idbasic` varchar(36) NOT NULL,
  `basic_date` datetime NOT NULL,
  `basic_numeric` decimal(18,0) NOT NULL,
  `basic_string` varchar(200) NOT NULL,
  `basic_uuid` varchar(200) NOT NULL,
  PRIMARY KEY  (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_basicuuid`
--

DROP TABLE IF EXISTS `tbl_basicuuid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_basicuuid` (
  `idbasic` varchar(200) NOT NULL,
  `basic_date` datetime NOT NULL,
  `basic_numeric` decimal(18,0) default '0',
  `basic_string` varchar(200) default 'gandalf',
  `basic_uuid` varchar(200) NOT NULL,
  PRIMARY KEY  (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_bigstuff`
--

DROP TABLE IF EXISTS `tbl_bigstuff`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_bigstuff` (
  `bigstuffid` varchar(36) NOT NULL,
  `bigstuff_clob` text,
  `bigstuff_blob` blob,
  PRIMARY KEY  USING BTREE (`bigstuffid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_c`
--

DROP TABLE IF EXISTS `tbl_c`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_c` (
  `c_id` varchar(200) NOT NULL,
  `lnkid` varchar(200) default NULL,
  `lnkid2` varchar(200) default NULL,
  `c_value` varchar(200) default NULL,
  PRIMARY KEY  (`c_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_childmanytooneuuid`
--

DROP TABLE IF EXISTS `tbl_childmanytooneuuid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_childmanytooneuuid` (
  `idchild` varchar(200) NOT NULL,
  `manytoonechild_string` varchar(200) NOT NULL,
  PRIMARY KEY  (`idchild`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_composite`
--

DROP TABLE IF EXISTS `tbl_composite`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_composite` (
  `idcomposite` varchar(200) NOT NULL,
  `composite_string` varchar(200) default NULL,
  `lnkidbasic` int(11) default NULL,
  PRIMARY KEY  (`idcomposite`),
  KEY `fk_comp` (`lnkidbasic`),
  CONSTRAINT `fk_comp` FOREIGN KEY (`lnkidbasic`) REFERENCES `tbl_onetomany` (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_d`
--

DROP TABLE IF EXISTS `tbl_d`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_d` (
  `d_id` varchar(200) NOT NULL,
  `lnkid` varchar(200) default NULL,
  `lnkid2` varchar(200) default NULL,
  `d_value` varchar(200) default NULL,
  PRIMARY KEY  (`d_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_generate`
--

DROP TABLE IF EXISTS `tbl_generate`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_generate` (
  `idgenerate` int(11) NOT NULL auto_increment,
  `generate_value` varchar(50) default NULL,
  PRIMARY KEY  (`idgenerate`),
  KEY `idGenerate` (`idgenerate`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_manytomanyuuid`
--

DROP TABLE IF EXISTS `tbl_manytomanyuuid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_manytomanyuuid` (
  `idsimple` varchar(200) NOT NULL,
  PRIMARY KEY  (`idsimple`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_manytooneuuid`
--

DROP TABLE IF EXISTS `tbl_manytooneuuid`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_manytooneuuid` (
  `idsimple` varchar(200) NOT NULL,
  `manytoone_string` varchar(200) NOT NULL,
  `lnkidchild` varchar(200) default NULL,
  PRIMARY KEY  (`idsimple`),
  KEY `fk_m2o` (`lnkidchild`),
  CONSTRAINT `fk_m2o` FOREIGN KEY (`lnkidchild`) REFERENCES `tbl_childmanytooneuuid` (`idchild`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_none`
--

DROP TABLE IF EXISTS `tbl_none`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_none` (
  `idbasic` int(11) NOT NULL auto_increment,
  `basic_string` varchar(200) default NULL,
  PRIMARY KEY  (`idbasic`),
  KEY `idbasic` (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_nonechild`
--

DROP TABLE IF EXISTS `tbl_nonechild`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_nonechild` (
  `idchild` int(11) NOT NULL auto_increment,
  `child_name` varchar(200) NOT NULL,
  `lnkbasicid` int(11) NOT NULL,
  PRIMARY KEY  (`idchild`),
  KEY `idchild` (`idchild`),
  KEY `fk_none` (`lnkbasicid`),
  CONSTRAINT `fk_none` FOREIGN KEY (`lnkbasicid`) REFERENCES `tbl_none` (`idbasic`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_onetomany`
--

DROP TABLE IF EXISTS `tbl_onetomany`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_onetomany` (
  `idbasic` int(11) NOT NULL auto_increment,
  `basic_string` varchar(50) default NULL,
  PRIMARY KEY  (`idbasic`),
  KEY `idbasic` (`idbasic`)
) ENGINE=InnoDB AUTO_INCREMENT=658 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_onetomanychild`
--

DROP TABLE IF EXISTS `tbl_onetomanychild`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_onetomanychild` (
  `idchild` int(11) NOT NULL auto_increment,
  `child_name` varchar(50) default NULL,
  `lnkbasicid` int(11) default NULL,
  PRIMARY KEY  (`idchild`),
  KEY `idchild` (`idchild`),
  KEY `fk_o2m` (`lnkbasicid`),
  CONSTRAINT `fk_o2m` FOREIGN KEY (`lnkbasicid`) REFERENCES `tbl_onetomany` (`idbasic`)
) ENGINE=InnoDB AUTO_INCREMENT=920 DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_propchild`
--

DROP TABLE IF EXISTS `tbl_propchild`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_propchild` (
  `idpropchild` int(11) NOT NULL auto_increment,
  `thing` varchar(50) default NULL,
  `lnkidpropparent` int(11) default NULL,
  PRIMARY KEY  (`idpropchild`),
  KEY `idpropchild` (`idpropchild`),
  KEY `fk_prop` (`lnkidpropparent`),
  CONSTRAINT `fk_prop` FOREIGN KEY (`lnkidpropparent`) REFERENCES `tbl_propparent` (`idpropparent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_propparent`
--

DROP TABLE IF EXISTS `tbl_propparent`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_propparent` (
  `idpropparent` int(11) NOT NULL auto_increment,
  `name` varchar(50) default NULL,
  `thing` varchar(50) default NULL,
  PRIMARY KEY  (`idpropparent`),
  KEY `idpropparent` (`idpropparent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_transaction`
--

DROP TABLE IF EXISTS `tbl_transaction`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_transaction` (
  `idtransaction` int(11) NOT NULL auto_increment,
  `string` varchar(50) default NULL,
  PRIMARY KEY  (`idtransaction`),
  KEY `idtransaction` (`idtransaction`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `tbl_tree`
--

DROP TABLE IF EXISTS `tbl_tree`;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
CREATE TABLE `tbl_tree` (
  `idtree` int(11) NOT NULL auto_increment,
  `tree_value` varchar(200) default NULL,
  `lnkidtree` int(11) default NULL,
  PRIMARY KEY  (`idtree`),
  KEY `idtree` (`idtree`),
  KEY `fk_tree` (`lnkidtree`),
  CONSTRAINT `fk_tree` FOREIGN KEY (`lnkidtree`) REFERENCES `tbl_tree` (`idtree`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
SET character_set_client = @saved_cs_client;


/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2009-06-03  6:26:45
