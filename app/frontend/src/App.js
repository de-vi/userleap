import './App.css';
import {Component} from 'react';
import Header from './Header.js';
import Content from './Content.js';
import Footer from './Footer.js';
import Grid from '@material-ui/core/Grid';
import TextField from '@material-ui/core/TextField';
import Button from '@material-ui/core/Button';

class App extends Component {
  constructor(props){
    super(props);
    this.state = {
      userEmail: '',
      submitted: false
    }
  }
  render() {
    if (this.state.userEmail !== '' && this.state.submitted) {
      return (
        <div className="App">
          <Grid container spacing={3}>
            <Grid item xs={12}>
              <Header />
            </Grid>
            <Grid item xs={12}>
              <Content userEmail={this.state.userEmail}/>
            </Grid>
            <Grid item xs={12}>
              <Footer />
            </Grid>
          </Grid>
        </div> );
      } else{
        return (
          <div className="App">
            <Grid container spacing={3}>
              <Grid item xs={12}>
                <Header />
              </Grid>
              <Grid item xs={12}>
                <TextField id="user-email" label="Email" onChange={(e)=> this.setState({userEmail: e.target.value})}/>
                <Button variant="contained" color="primary" onClick={()=> this.setState({submitted: true})}>
                  Next
                </Button>
              </Grid>
              <Grid item xs={12}>
                <Footer />
              </Grid>
            </Grid>
          </div> );
      }
  }
}

export default App;
