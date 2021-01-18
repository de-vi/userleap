import {Component} from 'react';
import CopyrightIcon from '@material-ui/icons/Copyright';

let footerStyle = {
    position: "fixed",
    bottom: 0,
    width: "100%"
}

class Footer extends Component {
    render() {
      return <div style={footerStyle}><p>All rights reserved 2021 <CopyrightIcon fontSize='small'/></p></div>;
    }
}

export default Footer;